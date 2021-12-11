{ pkgs, ... }:
{
  #nixpkgs.overlays = overlay;

  imports = [
    ./audio.nix
    ./core
    ./virtualization.nix
    ./graphics.nix
  ];
}
