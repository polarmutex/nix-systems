{ config, lib, pkgs, ... }:

{
  imports = [
    ./sound.nix
    ./xserver.nix
  ];

  options.polar.graphical.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.polar.graphical.enable {

    users.users.polar.extraGroups = [ "input" "video" ];

    polar = {
      base = { };
      graphical = {
        sound.enable = lib.mkDefault true;
        xserver.enable = lib.mkDefault true;
      };
    };

  };
}
