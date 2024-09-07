{ config, ... }:
{
  imports = [ ./cli/default.nix ] ++ [ ./gui/default.nix ];
}
