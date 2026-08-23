{ lib, ... }: {
  programs.fzf = {
    enable = lib.mkDefault true;
    defaultOptions = [ "--reverse" ];
  };
}
