{ inputs }:

final: prev: {
  #picom = prev.picom.overrideAttrs (old: {
  #  version = "unstable-2021-08-04";
  #  src = inputs.picom;
  #});

  #technic-launcher = prev.callPackage ./technic.nix { };
}
