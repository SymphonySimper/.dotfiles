{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dev.ai;

  llmAgentsPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.dev.ai = {
    packages = lib.mkOption {
      type = lib.types.listOf (lib.types.enum (builtins.attrNames llmAgentsPkgs));
      description = "List of packages from `numtide/llm-agents` to be installed";
      default = [ ];
    };
  };

  config = lib.mkIf (cfg.packages != [ ]) {
    home.packages = map (package: llmAgentsPkgs.${package}) (lib.lists.unique cfg.packages);
  };
}
