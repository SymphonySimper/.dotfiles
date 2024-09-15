{ ... }:
{
  programs.nixvim = {
    plugins.markview = {
      enable = true;
      settings = {
        modes = [
          "n"
          "no"
          "c"
        ];
        hybrid_modes = [ "n" ];
        callbacks = {
          on_enable.__raw = # lua
            ''
              function (_, win)
                 vim.wo[win].conceallevel = 2;
                 vim.wo[win].concealcursor = "c";
               end
            '';
        };
      };
    };
  };
}
