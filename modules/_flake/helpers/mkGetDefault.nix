{ lib, ... }:
let
  mkGetDefault =
    attr: key: default:
    let
      keyPath = lib.strings.splitString "." key;
    in
    if lib.attrsets.hasAttrByPath keyPath attr then
      lib.attrsets.getAttrFromPath keyPath attr
    else
      default;
in
mkGetDefault
