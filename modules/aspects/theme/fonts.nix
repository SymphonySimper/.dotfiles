{
  den.aspects.theme.fonts = {
    nixos.fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
    };

    homeManager =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        options.theme.fonts = {
          mono = lib.mkOption {
            type = lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Mono font name";
                };
                package = lib.mkOption {
                  type = lib.types.package;
                  description = "Mono font package";
                };
              };
            };
            default = {
              name = "JetBrainsMono Nerd Font";
              package = pkgs.nerd-fonts.jetbrains-mono.overrideAttrs {
                # refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerd-fonts/default.nix#L65
                preInstall = ''
                  find . -type f -not -regex ".*JetBrainsMonoNerdFont-\(Regular\\|Italic\\|Bold.*\).ttf" -delete
                '';
              };
            };
          };
        };

        config = {
          home.packages = [
            pkgs.noto-fonts-cjk-sans
            config.theme.fonts.mono.package
          ];
        };
      };
  };
}
