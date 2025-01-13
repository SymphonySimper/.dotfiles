{ ... }:
{
  my = {
    programs.nvim.treesitter = [
      "dockerfile"
    ];
    home.shell.aliases.docker_cln = "docker system prune --volumes";
  };
}
