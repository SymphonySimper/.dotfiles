{ pkgs, lib, ... }:
{
  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = false;
    };

    bash.initExtra =
      lib.mkOrder 2000 # sh
        ''
          eval "$(${lib.getExe pkgs.zoxide} init bash)"    
        '';
  };
}
