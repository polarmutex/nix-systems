{ config, lib, ... }:

{
  imports = [
    ./docker.nix
    ./virtualbox.nix
  ];

  options.polar.development.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.polar.development.enable {
    polar = {
      development = {
        docker.enable = lib.mkDefault true;
        virtualbox.enable = lib.mkDefault false;
      };
    };
  };
}
