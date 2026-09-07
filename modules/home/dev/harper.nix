{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.harper = {
    enable = lib.mkEnableOption "Harper";
  };

  config = lib.mkIf config.dev.harper.enable {
    programs.neovim = {
      extraPackages = [ pkgs.harper ];

      config.lsp = ''
        vim.lsp.enable("harper_ls") 
      '';
    };
  };
}
