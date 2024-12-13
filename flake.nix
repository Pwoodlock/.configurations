#
#           "DevSec Hardware Stack"
#
#
#  DevSec Various Versions of Nix for DD, Mobile, Cloud, BM
#  At some stage I will merge everything into one for personal use
#   
#  Lenovo Laptop "nixos-lenovo"   (Work Laptop)
#  Lenovo Laptop "nixos-480i"     (Personal Laptop)
#  Main daily driver Development PC "nixos-dd" 
#  Bare metal and Cloud NixOS Servers
#
#  Cloud
#
#


{
  description = "DevSec Hardware Stack";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # NixOS configurations
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nixos-dd = import ./devpc.nix;
          }
        ];
      };

      # Add other NixOS configurations here if needed
    };

    # Standalone home-manager configurations
    homeConfigurations = {
      "nixos-dd" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./devpc.nix ];
      };

      "nixos-lenovo" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./lenovo.nix ];
      };
    };
  };
}
