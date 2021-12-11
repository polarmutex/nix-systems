{ pkgs, config, lib, ... }:
with lib;
with builtins;
let
  desktopMode = (length config.sys.graphics.desktopProtocols) > 0;
in
{
  ## This is a list of core software I want to have on all of my machines.

  environment.systemPackages = with pkgs; [
    accountsservice
    wget
    curl
    bind
    killall
    dmidecode
    neofetch
    htop
    bat
    unzip
    file
    zip
    p7zip
    strace
    ltrace
    git
    git-crypt
    tmux
    zsh
    unrar
    acpi
    hwdata
    pciutils
    usbutils
    bintools
    smartmontools
    iotop
    parted
    xar
    pstree
    lf
    nix-index
    nmap

    lm_sensors

    python3 # I want to remove this eventually and get most dev dependancies out of my base environment
  ];

  # You need to add bash and zsh as login shells or dmlight won't recognise your user.
  environment.shells = [ pkgs.zsh pkgs.bash ];
}
