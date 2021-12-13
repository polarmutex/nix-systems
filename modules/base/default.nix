{ config, lib, pkgs, ... }:

{
  imports = [
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

