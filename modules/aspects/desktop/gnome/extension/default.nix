{
  den.aspects.desktop.gnome.extension = {
    homeManager = { pkgs, ... }: {
      programs.gnome-shell = {
        enable = true;

        extensions = [
          {
            # refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/desktops/gnome/extensions/buildGnomeExtension.nix
            package =
              let
                pname = "my";
                uuid = "my@symphonysimper.com";
              in
              pkgs.stdenv.mkDerivation {
                pname = "gnome-shell-extension-${pname}";
                uuid = uuid;
                version = "1";
                src = ./src;

                installPhase = ''
                  mkdir -p $out/share/gnome-shell/extensions/
                  cp -r -T . $out/share/gnome-shell/extensions/${uuid}
                '';

                passthru = {
                  extensionPortalSlug = pname;
                  extensionUuid = uuid;
                };
              };
          }
        ];
      };
    };
  };
}
