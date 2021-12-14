{ config, lib, pkgs, ... }:

{
  imports = [
    ./bluetooth.nix
    ./nixos.nix
    ./sshd.nix
  ];

  options.polar = {
    stateVersion = lib.mkOption {
      example = "21.05";
    };
  };
  config = {
    system.stateVersion = config.polar.stateVersion;

    environment.systemPackages = with pkgs; [
      git
      htop
      moreutils
      ripgrep
      unzip
      zip
      neovim
      lazygit
    ];

    security = {
      sudo.enable = false;
      doas = {
        enable = true;
        wheelNeedsPassword = false;
        extraRules = [
          {
            users = [ "polar" ];
            noPass = true;
            cmd = "nix-collect-garbage";
            runAs = "root";
          }
        ];
      };
    };

    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.zsh;
      users = {
        polar = {
          isNormalUser = true;
          home = "/home/polar";
          description = "PolarMutex";
          extraGroups = [ "wheel" ];
        };
      };
    };

  };
}

