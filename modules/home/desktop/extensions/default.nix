{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.desktop;

  sourcesDir = ./sources;

  extensionNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir sourcesDir)
  );

  mkExtension =
    name:
    let
      pname = "gnome-shell-extension-${name}";
      src = "${sourcesDir}/${name}";
      metadata = builtins.fromJSON (builtins.readFile (src + "/metadata.json"));
    in
    # refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/desktops/gnome/extensions/buildGnomeExtension.nix
    pkgs.stdenvNoCC.mkDerivation {
      inherit pname src;
      version = toString metadata.version;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/gnome-shell/extensions/
        cp -r -T . $out/share/gnome-shell/extensions/${metadata.uuid}

        runHook postInstall
      '';

      passthru = {
        extensionPortalSlug = pname;
        extensionUuid = metadata.uuid;
      };
    };
in
{
  options.desktop = {
    extensions.enable = lib.mkEnableOption "Extensions" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gnome-shell = {
      enable = true;

      extensions = map (extension: { package = extension; }) (
        (map mkExtension extensionNames)
        ++ [
          pkgs.gnomeExtensions.caffeine
          pkgs.gnomeExtensions.panel-free
        ]
      );
    };
  };
}
