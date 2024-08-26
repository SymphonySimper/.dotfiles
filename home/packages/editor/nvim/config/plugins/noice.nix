{ ... }:
{
  programs.nixvim.plugins = {
    noice = {
      enable = true;
      messages.view = "mini";
      notify.view = "mini";
    };
  };
}
