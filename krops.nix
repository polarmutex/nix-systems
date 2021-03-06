let

  # Basic krops setup
  krops = builtins.fetchGit { url = "https://cgit.krebsco.de/krops/"; };
  lib = import "${krops}/lib";
  pkgs = import "${krops}/pkgs" { };

  # Source is a function that takes `name` as argument and returns the sources
  # for the machine (config and nixpkgs).
  source = name:
    lib.evalSource [
      {

        # Secrets for the individual machines are copied from password-store.
        # Each machine has a folder containing it's own secrets.
        #secrets.pass = {
        #  dir = toString /home/pinpox/.local/share/password-store/nixos-secrets;
        #  name = name;
        #};

        # Copy over the whole repo. By default nixos-rebuild will use the
        # currents system hostname to lookup the right nixos configuration in
        # `nixosConfigurations` from flake.nix
        machine-config.file = toString ./.;
      }
    ];

  # In case the custom cache is down, systems can still be rebuild with:
  # nixos-rebuild switch --flake '.#hostname' --option substituters http://cache.nixos.org
  command = targetPath: ''
    nix-shell -p git --run '
      nixos-rebuild switch -v --show-trace --flake ${targetPath}/machine-config || \
        nixos-rebuild switch -v --flake ${targetPath}/machine-config
    '
  '';

  # Convenience function to define machines with connection parameters and
  # configuration source
  createHost = name: target:
    pkgs.krops.writeCommand "deploy-${name}" {
      inherit command;
      source = source name;
      target = target;
    };

in
rec {

  # Define deployments

  # Run with (e.g.):
  # nix-build ./krops.nix -A polarvortex && ./result

  # Individual machines
  polarvortex = createHost "polarvortex" "root@100.97.125.108";
  polarbear = createHost "polarbear" "root@10.11.11.146";

  # Groups
  all = pkgs.writeScript "deploy-all"
    (lib.concatStringsSep "\n" [ polarvortex ]);

  servers = pkgs.writeScript "deploy-servers"
    (lib.concatStringsSep "\n" [ polarvortex ]);
}
