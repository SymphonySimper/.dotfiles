{ ... }: {
  programs.hyprland.enable = true;
  services.xserver.displayManager.lightdm.enable = false;
}
