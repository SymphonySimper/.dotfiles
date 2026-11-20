{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.btop;
in
{
  options.programs.btop = {
    gpu = {
      amd = lib.mkEnableOption "AMD";
      nvidia = lib.mkEnableOption "Nvidia";
    };
  };

  config = {
    programs.btop = {
      enable = lib.mkDefault true;

      package = pkgs.btop.override {
        # GPU support
        rocmSupport = cfg.gpu.amd; # amd
        cudaSupport = cfg.gpu.nvidia; # nvida
      };

      settings = {
        vim_keys = true;
        shown_boxes = "cpu mem net proc gpu0";
        update_ms = 2000; # recommended
        proc_tree = false;
      };
    };
  };
}
