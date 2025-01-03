{ inputs, ... }:
{
  helpers = import ./helpers { inherit inputs; };
  templates = import ./templates;
}
