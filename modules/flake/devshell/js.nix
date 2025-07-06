{ pkgs, ... }:
{
  packages = with pkgs; [
    nodejs
    corepack
  ];

  env = {
    PNPM_HOME = "$XDG_DATA_HOME/pnpm";
    PATH = "$PATH:$PNPM_HOME";
  };

}
