{ pkgs, lib, config, ... }:
with builtins;
with lib;
let
  cfg = config.sys.users;
in
{
  options.sys.users = {

    primaryUser = {
      name = mkOption {
        type = types.str;
        default = "polar";
        description = "The username of the primary user on the system";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Extra groups to add to primary user";
      };

      shell = mkOption {
        type = types.package;
        default = pkgs.zsh;
        description = "Sets the shell used by primary user";
      };

    };
  };

  config = {
    users.users."${cfg.primaryUser.name}" = {
      name = cfg.primaryUser.name;
      isNormalUser = true;
      isSystemUser = false;
      group = cfg.primaryUser.name;
      extraGroups = cfg.primaryUser.extraGroups;
      uid = 1000;
      initialPassword = "P@ssw0rd01";
    };

    users.users.root = {
      name = "root";
      initialPassword = "P@ssw0rd01";
    };

  };
}
