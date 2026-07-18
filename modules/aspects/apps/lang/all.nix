{ den, ... }: {
  den.aspects.apps.lang.all = {
    includes = with den.aspects.apps.lang; [
      default

      go
      python
      rust
      tree-sitter
      web
    ];
  };
}
