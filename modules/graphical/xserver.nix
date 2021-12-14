{ config, pkgs, lib, ... }:
{

  options.polar.graphical.xserver = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
    primaryGPU = lib.mkOption {
      type = lib.types.enum [ "amd" "intel" "nvidia" "none" ];
      default = "none";
      description = "The primary gpu on your system that you want your desktop to display on";
    };
  };

  config =
    let
      intel = (config.polar.graphical.xserver.primaryGPU == "intel");
      intelPrimary = config.polar.graphical.xserver.PrimaryGPU == "intel";

      nvidia = (config.polar.graphical.xserver.primaryGPU == "nvidia");
      nvidiaPrimary = config.polar.graphical.xserver.PrimaryGPU == "nvidia";

      headless = config.polar.graphical.xserver.primaryGPU == "none";
    in
    lib.mkIf config.polar.graphical.xserver.enable {

      hardware.video.hidpi.enable = lib.mkDefault true;

      services.autorandr.enable = true;
      services.xserver = {
        enable = true;
        autorun = true;
        layout = "us";
        dpi = 163;

        videoDrivers = [
          (lib.mkIf intel "intel")
          (lib.mkIf nvidia "nvidia")
        ];


        displayManager.lightdm.enable = true;

        desktopManager = {
          xterm.enable = false;
          session = [
            {
              name = "awesome";
              start = ''
                 ${pkgs.awesome}/bin/awesome &
                waitPID=$!
              '';
            }
            {
              name = "home-manager";
              start = ''
                 ${pkgs.runtimeShell} $HOME/.xsession-hm &
                waitPID=$!
              '';
            }
            {
              name = "dwm";
              start = ''
                 ${pkgs.dwm}/bin/dwm &
                waitPID=$!
              '';
            }
          ];
        };
      };
      hardware.nvidia.modesetting.enable = nvidia;
      environment.systemPackages = with pkgs; [
        glxinfo
        st
        dmenu
        (lib.mkIf intel libva-utils)
      ];

      fonts.fonts = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];
    };

}
