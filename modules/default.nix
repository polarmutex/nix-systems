{ pkgs, ... }:
{
  imports = [
    ./base
    ./development
    ./graphical
    ./services
  ];
}
