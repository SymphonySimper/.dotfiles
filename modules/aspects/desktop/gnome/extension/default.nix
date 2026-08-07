{ inputs, ... }: {
  flake-file.inputs = {
    gnome-extension-panel-free = {
      url = "github:fthx/panel-free";
      flake = false;
    };
  };

  den.aspects.desktop.gnome.extension = {
    homeManager =
      { pkgs, ... }:
      let
        # refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/desktops/gnome/extensions/buildGnomeExtension.nix
        mkExtension = pname: uuid: src: {
          package = pkgs.stdenv.mkDerivation {
            pname = "gnome-shell-extension-${pname}";
            uuid = uuid;
            version = "1";
            src = src;

            installPhase = ''
              mkdir -p $out/share/gnome-shell/extensions/
              cp -r -T . $out/share/gnome-shell/extensions/${uuid}
            '';

            passthru = {
              extensionPortalSlug = pname;
              extensionUuid = uuid;
            };
          };
        };
      in
      {
        programs.gnome-shell = {
          enable = true;

          extensions = [
            (mkExtension "my" "my@symphonysimper.com" ./src)
            (mkExtension "panel-free" "panel-free@fthx" inputs.gnome-extension-panel-free)
          ];
        };
      };
  };
}
