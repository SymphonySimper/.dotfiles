{ ... }: {
  programs.nixvim = {
    otter = {
      enable = true;

      settings = {
        buffers.write_to_disk = true;
        handle_leading_whitespace = true;
      };
    };
    cmp.settings.sources = [{ name = "otter"; }];
  };
}
