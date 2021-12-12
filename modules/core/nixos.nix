{ pkgs, config, lib, ... }:
{
  nix = {
    package = pkgs.nixFlakes;
    #extraOptions = ''experimental-features = nix-command flakes'';
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
  };
}
