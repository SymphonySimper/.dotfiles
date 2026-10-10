{ ... }: {
  programs.nixvim = {
    plugins.ts-autotag = {
      enable = true;
      settings.opts.enable_rename = true;
    };
  };
}
