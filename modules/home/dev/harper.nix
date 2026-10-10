{ config, lib, ... }: {
  options.dev.harper = {
    enable = lib.mkEnableOption "Harper";
  };

  config = lib.mkIf config.dev.harper.enable {
    programs.nixvim = {
      lsp.servers.harper_ls.enable = true;
    };
  };
}
