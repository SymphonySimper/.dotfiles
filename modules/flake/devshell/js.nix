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

  shellHook = # sh
    ''
      alias jp="pnpm"
      alias jpi="pnpm i"
      alias jprd="pnpm run dev"
      alias jpf="pnpm format"
      alias jn="npm"
      alias jni="npm i"
      alias jnrd="npm run dev"
      alias jnf="npm run format"
    '';
}
