{ ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      "work-github" = {
        hostname = "github.com";
        identityFile = "~/.ssh/work_id_ed25519";
        identitiesOnly = true;
      };
    };
  };
}
