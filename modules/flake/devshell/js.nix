{ pkgs, ... }:
{
  packages = with pkgs; [
    nodejs
    corepack
  ];

  shellHook = # sh
    ''
      export PNPM_HOME="$XDG_DATA_HOME/pnpm"
      export PATH="$PATH:$PNPM_HOME"

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
