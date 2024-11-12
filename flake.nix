# First in a line of Flake configuration files etc for Github CI/CD
#
# https://librephoenix.com/2023-10-21-intro-flake-config-setup-for-new-nixos-users.html
# 
# nix flake update
# sudo nixos-rebuild switch --flake .#NAMEOFCONFIGURATION
#
# ****** HOME-MANAGER *********
# 
#
#
#
# *** The below is the Nix Channel for Unstable for Home Manager
# nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --update
# nix-shell '<home-manager>' -A install
#
#  To rebuild and update you type
#
# home-manager switch --flake .  (Which is for the default user)
# And then theres a another for that type of configuration
# 
#  home-manager switch --flake .#nixos-dd which is what my user here is called at the moment.
#


{
  description = "Daily Driver Flake";

  inputs = {
    #nixpkgs.url = "nixpkgs/nixos-23.05";

    # use the following for unstable:
    nixpkgs.url = "nixpkgs/nixos-unstable"; # Using Unstable for now as I will use both at a later stage. Unstable is practically Rolling Release like Arch
    # or any branch you want:
    # nixpkgs.url = "nixpkgs/{BRANCH-NAME}";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";



  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages. ${system};
    system = "x86_64-linux";
    in {



    nixosConfigurations = {
      # nixos is the name of the system and in this case the primary configuration. We Will add more configurations later.
     nixos = lib.nixosSystem {
      inherit system;
      modules = [ ./configuration.nix ];
     };
   };

    homeConfigurations = {
    # Now it's nixos-dd which is the actual users home directory.
    nixos-dd = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./devpc.nix ];
    };


    };
  };

}
