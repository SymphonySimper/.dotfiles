{ myUtils, ... }:
{
  programs.nixvim = {
    plugins.otter = {
      enable = true;

      settings = {
        buffers.write_to_disk = true;
        handle_leading_whitespace = true;
      };
    };
    keymaps = myUtils.mkKeymaps [
      [
        { __raw = "require('otter').activate"; }
        "<leader>oa"
        "n"
        "Activate otter"
      ]
      [
        { __raw = "require('otter').deactivate"; }
        "<leader>od"
        "n"
        "Deactivate otter"
      ]
    ];
  };
}
