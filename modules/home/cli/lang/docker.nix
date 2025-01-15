{ ... }:
{
  programs.nixvim.plugins.treesitter.grammars = [
    "dockerfile"
  ];

  home.shellAliases.docker_cln = "docker system prune --volumes";
}
