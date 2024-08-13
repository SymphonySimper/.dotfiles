{ ... }:
{
  programs.nixvim = {
    plugins.markview = {
      enable = true;
      settings = {
        hybrid_modes = [
          "i"
          "r"
        ];
      };
    };
  };
}
