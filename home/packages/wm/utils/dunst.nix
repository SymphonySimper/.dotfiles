{ ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "top-right";
      };
    };
  };
}
