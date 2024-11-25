{ ... }:
{
  programs = {
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        background_update = false;
      };
    };
    htop = {
      enable = true;
      settings = {
        color_scheme = 0;

        tree_view = 1;
        all_branches_collapsed = 1;
        show_program_path = 0;
        highlight_base_name = 1;

        hide_kernel_threads = 1;
      };
    };
  };
}
