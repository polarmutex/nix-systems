{ config, pkgs, lib, ... }:
with lib;
with builtins;
let
  cfg = config.sys;
in
rec {

  imports = [
    ./nixos.nix
    ./software.nix
    ./security.nix
    ./regional.nix
  ];
  options.sys = {
    kernelPackage = mkOption {
      default = pkgs.linuxPackages_latest;
      description = "Kernel package used to build this system";
    };

    diskLayout = mkOption {
      type = types.enum [ "btrfs-crypt" "vm" ];
      description = "This is the layout of the disk used by the system.";
      default = "btrfs-crypt";
    };

    bootloader = mkOption {
      type = types.enum [ "grub" "systemd-boot" ];
      description = "The boot loader used to boot the system";
      default = "systemd-boot";
    };

    biosType = mkOption {
      type = types.enum [ "efi" "bios" ];
      description = "Specify the bios type of the machine";
    };

    bluetooth = mkEnableOption "System has a bluetooth adapter";

    cpu = {
      type = mkOption {
        type = types.enum [ "intel" "amd" ];
        description = "Type of cpu the system has in it";
      };

      cores = mkOption {
        type = types.int;
        default = 1;
        description = "Number of physical cores on cpu per socket";
      };

      sockets = mkOption {
        type = types.int;
        default = 1;
        description = "Number of CPU sockets installed in system";
      };

      threadsPerCore = mkOption {
        type = types.int;
        default = 1;
        description = "Number of threads per core.";
      };

      sensorCommand = mkOption {
        type = types.str;
        description = "Command to get cpu temp";
      };
    };
  };

  config = {

    # Earlyoom prevents systems from locking up when they run out of memory
    services.earlyoom.enable = true;

    # TTY font
    console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

    # Enable all unfree hardware support.
    hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;
    nixpkgs.config.allowUnfree = true;

    boot.kernelPackages = cfg.kernelPackage;
    boot.kernelParams = [
      (mkIf (cfg.cpu.type == "intel") "intel_pstate=active")
    ];

    environment.systemPackages = with pkgs; [
      (mkIf (cfg.cpu.type == "amd") microcodeAmd)
      (mkIf (cfg.cpu.type == "intel") microcodeIntel)
    ];

    boot.loader.systemd-boot.enable = cfg.bootloader == "systemd-boot";
    boot.loader.efi.canTouchEfiVariables = cfg.bootloader == "systemd-boot";

    boot.loader.grub.enable = cfg.bootloader == "grub";
    boot.loader.grub.version = 2;
    boot.loader.grub.device = "/dev/sda";

    nix.maxJobs = cfg.cpu.cores * cfg.cpu.threadsPerCore * cfg.cpu.sockets;


    hardware.bluetooth.enable = cfg.bluetooth;
    services.blueman.enable = cfg.bluetooth;

    fileSystems."/" = (if (cfg.diskLayout == "btrfs-crypt") then
      {
        device = "/dev/disk/by-label/ROOT";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      }
    else
      {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      });

    swapDevices = (mkIf (cfg.diskLayout == "vm") [
      {
        device = "/dev/disk/by-label/swap";
      }
    ]);
  };
}
