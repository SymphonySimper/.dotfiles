{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (google-fonts.override { fonts = [ "Poppins" ]; })
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
}
