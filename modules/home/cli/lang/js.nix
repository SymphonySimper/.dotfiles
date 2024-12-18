{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      nodejs
      corepack
      # nodePackages_latest.npm
      # nodePackages_latest.pnpm
    ];

    shellAliases = {
      jp = "pnpm";
      jpi = "pnpm i";
      jprd = "pnpm run dev";
      jpf = "pnpm format";
      jn = "npm";
      jni = "npm i";
      jnrd = "npm run dev";
      jnf = "npm run format";
    };

    sessionVariables = rec {
      PNPM_HOME = "${config.xdg.dataHome}/pnpm";
      PATH = "$PATH:${PNPM_HOME}";
    };
  };
}
