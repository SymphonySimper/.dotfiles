{ ... }:
{
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      silent = true;
      config.warn_timeout = "2m";
    };

    helix.ignore = [
      "!.envrc"
      ".direnv"
    ];
  };
}
