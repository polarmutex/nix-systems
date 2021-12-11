{ system, pkgs, lib, ... }:
with builtins;
{
  mkHost =
    { name
    , cfg ? { }
    , NICs
    , initrdMods
    , kernelParams
    , kernelMods
    , wifi ? [ ]
    , gpuTempSensor ? null
    , cpuTempSensor ? null
    }:
    let
      networkCfg = listToAttrs (map
        (n: {
          name = "${n}";
          value = { useDHCP = true; };
        })
        NICs);

      secretsResult = tryEval (import ../.secret/default.nix);
      secrets = if secretsResult.success then secretsResult.value else { };


      flaten = lst: foldl' (l: r: l // r) { } lst;

    in
    lib.nixosSystem {
      inherit system;

      modules = [
        cfg
        {
          imports = [ ../modules ];

          sys.security.secrets = secrets;

          networking.hostName = "${name}";
          networking.interfaces = networkCfg;
          networking.wireless.interfaces = wifi;

          networking.networkmanager.enable = true;
          networking.useDHCP = false; # Disable any new interface added that is not in config.

          boot.initrd.availableKernelModules = initrdMods;
          boot.kernelModules = kernelMods;
          boot.kernelParams = kernelParams;

          nixpkgs.pkgs = pkgs;

          system.stateVersion = "21.05";

        }

      ];
    };


}
