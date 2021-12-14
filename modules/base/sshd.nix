{ pkgs, config, lib, ... }:
{
  # Enable SSHD
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  services.openssh.passwordAuthentication = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowPing = true;

  users.users.polar.openssh.authorizedKeys.keyFiles = [
    (
      builtins.fetchurl {
        url = "https://github.com/polarmutex.keys";
        sha256 = "sha256:01vg72kgaw8scgmfif1sm9wnzq3iis834gn8axhpwl2czxcfysl9";
      }
    )
  ];
  users.users.root.openssh.authorizedKeys.keyFiles = [
    (
      builtins.fetchurl {
        url = "https://github.com/polarmutex.keys";
        sha256 = "sha256:01vg72kgaw8scgmfif1sm9wnzq3iis834gn8axhpwl2czxcfysl9";
      }
    )
  ];
}
