{ pkgs, lib, ... }:
{
  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = false;
    };

    bash.initExtra =
      lib.mkAfter # sh
        ''
          eval "$(${lib.getExe pkgs.zoxide} init bash)"    
        '';
  };
}
