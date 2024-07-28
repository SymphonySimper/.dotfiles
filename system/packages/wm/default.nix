{ userSettings, ... }: {
  imports = (if userSettings.programs.wm then [
    ./sway.nix
  ] else [
    ./gnome.nix
  ]);

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

