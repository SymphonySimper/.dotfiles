{
  mouse = false;
  line-number = "relative";
  auto-format = false;
  bufferline = "never";
  auto-pairs = true;
  indent-guides.render = false;
  soft-wrap.enable = true;
  buffer-picker.start-position = "current";

  cursor-shape = rec {
    normal = "block";
    insert = "bar";
    select = normal;
  };

  auto-completion = true;
  path-completion = true;
  preview-completion-insert = true;
  completion-replace = true;
  word-completion = {
    enable = true;
    trigger-length = 4;
  };

  end-of-line-diagnostics = "hint";
  inline-diagnostics.cursor-line = "warning";
  lsp = {
    enable = true;
    display-inlay-hints = false;
    auto-signature-help = false;
    display-color-swatches = false;
  };

  statusline = {
    left = [
      "mode"
      "file-name"
    ];

    right = [
      "spinner"
      "diagnostics"
      # "version-control"
      "selections"
      "register"
      "position"
      "total-line-numbers"
      "read-only-indicator"
      "file-modification-indicator"
    ];
  };
}
