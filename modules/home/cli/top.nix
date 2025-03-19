{ lib, config, ... }:
{
  programs.htop = {
    enable = true;

    settings = lib.mkMerge [
      {
        color_scheme = 0;

        tree_view = 1;
        all_branches_collapsed = 1;
        show_program_path = 0;
        highlight_base_name = 1;

        hide_kernel_threads = 1;
      }

      (
        with config.lib.htop;
        leftMeters [
          (bar "CPU")
          (bar "LeftCPUs2")
          (bar "Memory")
          (bar "Swap")
        ]
      )

      (
        with config.lib.htop;
        rightMeters [
          (bar "RightCPUs2")
          (text "Tasks")
          (text "LoadAverage")
          (text "Uptime")
        ]
      )
    ];
  };
}
