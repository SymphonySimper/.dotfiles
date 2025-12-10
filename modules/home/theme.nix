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

      (nerd-fonts.jetbrains-mono.overrideAttrs {
        # refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerd-fonts/default.nix#L65
        preInstall =
          let
            variants = builtins.concatStringsSep "\\|" [
              "Regular"
              "Italic"
              "Bold.*"
            ];
          in
          # sh
          ''
            find . -type f -not -regex ".*JetBrainsMonoNerdFont-\(${variants}\).ttf" -delete
          '';
      })
    ];

    dconf = {
      enable = true;

      settings."org/gnome/desktop/interface" = {
        color-scheme = if my.theme.dark then "prefer-dark" else "default";
      };
    };
  };
}
