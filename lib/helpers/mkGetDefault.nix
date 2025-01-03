{ lib, ... }:
let
  mkGetDefault =
    attr: key: default:
    let
      path = lib.strings.splitString "." key;
    in
    if lib.attrsets.hasAttrByPath path attr then lib.attrsets.getAttrFromPath path attr else default;
in
mkGetDefault
