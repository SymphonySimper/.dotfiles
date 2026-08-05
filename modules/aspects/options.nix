# NOTE: Do not add any options to this file.
# This is boilerplate to setup options without including the aspect.
{ den, ... }: {
  den.default.includes = [ den.aspects.options ];
  den.aspects.options = { };
}
