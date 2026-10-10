{ ... }: {
  programs.nixvim = {
    lsp = {
      codelens.enable = true;
      completion.enable = true;
      documentColor.enable = true;
      linkedEditingRange.enable = true;
    };

    plugins.lspconfig.enable = true;
  };
}
