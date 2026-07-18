{ den, ... }: {
  den.aspects.apps.lang.all = {
    includes = with den.aspects.apps.lang; [
      config
      english
      go
      markdown
      nix
      python
      rust
      tree-sitter
      web
    ];
  };
}
