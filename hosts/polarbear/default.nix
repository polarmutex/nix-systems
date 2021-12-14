{ pkgs, ... }:
{
  imports =
    [
      ./hardware.nix
    ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  polar = {
    stateVersion = "21.05";
    base = {
      bluetooth.enable = true;
    };
    development = {
      enable = false;
    };
    graphical.enable = true;
  };

  users.users.root = {
    initialPassword = "root";
  };

}

