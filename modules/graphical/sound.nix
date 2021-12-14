{ config, lib, pkgs, ... }:

{
  options.polar.graphical.sound.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.polar.graphical.sound.enable {
    sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
}
