{ userSettings, ... }:
{
  imports = [
    ./alacritty.nix
    ./browser.nix
    ./dconf.nix
    ./dev.nix
    ./media/default.nix
    ./office.nix
    ./productivity.nix
    ./theme.nix
    ./wezterm/default.nix
  ] ++ (if userSettings.programs.wm then [
    ./hyprland/default.nix
  ] else [ ]);
}
