{ ... }: {
  programs.nixvim = {
    lsp = {
      codelens.enable = true;
      completion.enable = false; # handled by blink
      documentColor.enable = true;
      linkedEditingRange.enable = true;
    };

    plugins.lspconfig.enable = true;
  };
}
