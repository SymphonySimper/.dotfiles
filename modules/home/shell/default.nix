{ config, ... }: {
  imports = [
    ./bash.nix
    ./nushell.nix

    ./fish
  ];

  home = {
    sessionVariables = {
      LS_COLORS = ""; # Some programs misbehave when this is not set.
    };

    sessionPath = [ "${config.xdg.dataHome}/../bin" ];
  };
}
