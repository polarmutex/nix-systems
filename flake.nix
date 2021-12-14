{
  description = "PolarMutex Nixos configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    neovim = {
      url = github:neovim/neovim?dir=contrib;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager/release-21.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    polar-dwm.url = "github:polarmutex/dwm";
    polar-dmenu.url = "github:polarmutex/dmenu";
    polar-st.url = "github:polarmutex/st";

  };

  outputs =
    inputs @ { self
    , nixpkgs
    , utils
    , neovim
    , home-manager
    , polar-dwm
    , polar-st
    , polar-dmenu
    , ...
    }:
    utils.lib.mkFlake {
      inherit self inputs;

      channels.nixpkgs = {
        input = nixpkgs;
        overlaysBuilder = _: [
          neovim.overlay
          polar-dwm.overlay
          polar-st.overlay
          polar-dmenu.overlay
        ];
      };
      channelsConfig.allowUnfree = true;

      hostDefaults = {
        modules = [
          ./modules
          home-manager.nixosModules.home-manager
        ];
        extraArgs = { nixosConfigurations = self.nixosConfigurations; };
      };

      hosts = {
        polarbear.modules = [ ./hosts/polarbear ];
      };

      outputsBuilder = channels: with channels.nixpkgs; {
        devShell = mkShell {
          name = "nix-systems";
          buildInputs = [
            git-crypt
          ];
        };
      };
    };
}
