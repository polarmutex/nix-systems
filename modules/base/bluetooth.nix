{ config, lib, pkgs, ... }:
{
  options.polar.base.bluetooth.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.polar.base.bluetooth.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
