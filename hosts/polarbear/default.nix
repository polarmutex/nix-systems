{ pkgs, ... }:
{
  imports =
    [
      ./hardware.nix
    ];

  # Set your time zone.
  time.timeZone = "Americas/NewYork";

  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  polar = {
    stateVersion = "21.05";
  };

  users.users.root = {
    initialPassword = "root";
  };

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = "experimental-features = nix-command flakes";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "yes";

}

