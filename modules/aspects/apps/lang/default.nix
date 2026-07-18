{ den, ... }: {
  den.aspects.apps.lang.default = {
    includes = with den.aspects.apps.lang; [
      config
      english
      markdown
      nix
    ];
  };
}
