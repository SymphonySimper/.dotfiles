{ config, ... }:
{
  imports = [
    ./browser/default.nix
    ./dconf.nix
    ./media/default.nix
    ./office.nix
    ./productivity.nix
    ./alacritty.nix
    ./theme.nix
    ./zathura.nix
    ./desktop/default.nix
  ];
}
