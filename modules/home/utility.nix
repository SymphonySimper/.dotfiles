{
  my,
  pkgs,
  lib,
  ...
}:
{
  home.packages = builtins.concatLists [
    # Clipboard
    (lib.lists.optional (my.gui.enable && pkgs.stdenv.hostPlatform.isLinux) pkgs.wl-clipboard)
  ];

  programs = {
    man = {
      enable = true;
      generateCaches = true;
    };

    btop = {
      enable = true;

      package = pkgs.btop.override {
        # GPU support
        rocmSupport = true; # amd
        cudaSupport = true; # nvida
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
