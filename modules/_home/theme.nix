{
  my,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf my.gui.enable {
    home.packages = with pkgs; [
      noto-fonts-cjk-sans

      (
        let
          # refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerd-fonts/default.nix#L65
          variants = builtins.concatStringsSep "\\|" [
            "Regular"
            "Italic"
            "Bold.*"
          ];
        in
        nerd-fonts.jetbrains-mono.overrideAttrs {
          preInstall = ''
            find . -type f -not -regex ".*JetBrainsMonoNerdFont-\(${variants}\).ttf" -delete
          '';
        }
      )
    ];

    dconf = {
      enable = true;

      settings."org/gnome/desktop/interface" = {
        color-scheme = if my.theme.dark then "prefer-dark" else "default";
      };
    };
  };
}
