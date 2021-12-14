{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.sys.virtualisation;
  cpuType = config.sys.cpu.type;

in
{
  options.polar.development.virtualbox.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.polar.development.virtualbox.enable {
    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;
  };
}
