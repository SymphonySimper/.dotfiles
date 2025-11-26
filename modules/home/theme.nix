{
  my,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf my.gui.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          noto-fonts-cjk-sans

          (nerd-fonts.jetbrains-mono.overrideAttrs {
            # refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerd-fonts/default.nix#L65
            postInstall =
              let
                variants = builtins.concatStringsSep "\\|" [
                  "Regular"
                  "Italic"
                  "Bold.*"
                ];
              in
              # sh
              ''
                find "$dst_truetype" -type f -not -regex ".*JetBrainsMonoNerdFont-\(${variants}\).ttf" -delete
              '';
          })
        ];
      }

      {
        dconf = {
          enable = true;

          settings."org/gnome/desktop/interface" = {
            color-scheme = if my.theme.dark then "prefer-dark" else "default";
            toolkit-accessibility = false;
          };
        };
      }
    ]
  );
}
