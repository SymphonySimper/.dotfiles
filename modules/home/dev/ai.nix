{ inputs, pkgs, ... }: {
  _module.args = {
    aiPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  };
}
