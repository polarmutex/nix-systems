{ config, lib, pkgs, ... }:

{
  options.polar.development.docker.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.polar.development.docker.enable {
    virtualisation.docker = {
      enable = true;
    };

    environment.systemPackages = [ pkgs.docker-compose ];

    users.users.polar.extraGroups = [ "docker" ];
  };
}
