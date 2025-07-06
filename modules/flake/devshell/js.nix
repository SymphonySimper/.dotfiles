{ pkgs, ... }:
{
  packages = with pkgs; [
    nodejs
    corepack
  ];

  shellHook = ''
    export PNPM_HOME="$XDG_DATA_HOME/pnpm";
    export PATH="$PATH:$PNPM_HOME";
  '';
}
