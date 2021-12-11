{
  description = "PolarMutex Nixos configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      inherit (lib) attrValues;

      util = import ./lib { inherit system pkgs lib; overlays = (pkgs.overlays); };

      inherit (util) host;

      pkgs = import nixpkgs {
        inherit system;
        config = { allowBroken = true; allowUnfree = true; };
        overlays = [
          (final: prev: {
            my = import ./pkgs { inherit pkgs; };
          })
        ];
      };

      system = "x86_64-linux";
    in
    {
      packages."${system}" = pkgs;

      devShell."${system}" = import ./shell.nix { inherit pkgs; };

      nixosConfigurations = {
        polarbear = host.mkHost {
          name = "polarbear";
          NICs = [ "enp0s3" ];
          initrdMods = [ "ata_piix" "ohci_pci" "ehci_pci" "sd_mod" "sr_mod" ];
          kernelMods = [ ];
          kernelParams = [ ];

          cfg = {
            sys.kernelPackage = pkgs.linuxPackages_latest;
            sys.bootloader = "grub";
            sys.diskLayout = "vm";
            sys.locale = "en_EN.UTF-8";
            sys.timeZone = "America/NewYork";
            sys.virtualisation.kvm.enable = false;
            sys.virtualisation.docker.enable = false;
            sys.cpu.type = "intel";
            sys.cpu.cores = 2;
            sys.cpu.threadsPerCore = 1;
            sys.biosType = "grub";
            sys.graphics.displayManager = "lightdm";
            sys.graphics.desktopProtocols = [ "xorg" ];
            sys.audio.server = "pulse";

            sys.security.yubikey = true;
            sys.security.username = "polar";
          };
        };
      };
    };
}
