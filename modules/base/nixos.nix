{ config, lib, pkgs, ... }:
let
in
{
  options.polar.base.nix = {
    unfreePackages = lib.mkOption {
      default = [ ];
      example = [ "teams" ];
    };
  };

  config = {

    nix = {
      gc = {
        automatic = true;
        dates = "hourly";
        options = "--delete-older-than 7d";
      };
      optimise = {
        automatic = true;
        dates = [ "hourly" ];
      };
      trustedUsers = [ "@wheel" ];
      extraOptions = "experimental-features = nix-command flakes";
      package = pkgs.nixFlakes;
    };

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.polar.base.nix.unfreePackages;

  };
}
