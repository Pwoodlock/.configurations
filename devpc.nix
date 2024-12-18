{ config, pkgs, ... }:

####################################################
# Section for setting up variables
####################################################

let
  myAliases = {
    ll  = "ls -l";
    ".." = "cd ..";
  };
in

#####################################################
# Home Manager Configuration
#####################################################

{
  # Basic Home Manager settings
  home.username = "nixos-dd";
  home.homeDirectory = "/home/nixos-dd";
  nixpkgs.config.allowUnfree = true;

  # Home Manager release version for compatibility
  home.stateVersion = "24.11";  # Please read the comment before changing

  # Packages to install in the user's environment
  home.packages = [
    #     Terminal Related Applications

    pkgs.oh-my-posh
    pkgs.nushell
    pkgs.starship
    pkgs.carapace
    pkgs.pinentry-qt



    #     Browsers

    pkgs.microsoft-edge
    pkgs.ungoogled-chromium
    
    #     Wine Based Tools
    pkgs.lutris
    pkgs.protonup-qt



    #****************************************
    #       Dev Tools etc & Packages
    pkgs.vscode
    pkgs.vscode-extensions.github.copilot
    pkgs.terraform
    pkgs.packer
    pkgs.ansible
    pkgs.podman
    pkgs.kubectl
    pkgs.helm
    pkgs.ansible-lint
    pkgs.python313

    # --> EDA Tools
    #






    # System Tools
    pkgs.appimage-run
    pkgs.gparted




    # User Applications
    pkgs.netbird
    pkgs.netbird-ui
    pkgs.obsidian
    pkgs.discord
    pkgs.openscad
    pkgs.angryipscanner
    pkgs.unetbootin
    pkgs.freecad
    pkgs.libreoffice
    pkgs.virt-viewer
    pkgs.nextcloud-client
    pkgs.inkscape-with-extensions
    pkgs.krita
    pkgs.gimp-with-plugins


  ];

  # Manage user files (optional section)
  home.file = {
    # Example of managing dotfiles (e.g. .screenrc)
    # ".screenrc".source = dotfiles/screenrc;
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Manage environment variables
  home.sessionVariables = {
    # Example environment variable configuration
    # EDITOR = "emacs";
  };

######################################################
#
#              Programs Configuration




  programs = {
    # Bash shell configuration
    bash = {
      enable = true;
      shellAliases = myAliases;
    };

    # Zsh shell configuration
    zsh = {
      enable = true;
      shellAliases = myAliases;
    };



    # Git configuration
    git = {
      enable = true;
      userName = "PWoodlock";
      userEmail = "patrick@devsec.ie";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    # Nushell configuration
    nushell = {
      enable = true;
      extraConfig = ''
        let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
        }
        $env.config = {
          show_banner: false,
          completions: {
            case_sensitive: false
            quick: true
            partial: true
            algorithm: "fuzzy"
            external: {
              enable: true
              max_results: 100
              completer: $carapace_completer
            }
          }
        }
        $env.PATH = ($env.PATH | split row (char esep) | prepend /home/nixos-lenovo/.apps | append /usr/bin/env)
      '';
      shellAliases = {
        vi   = "hx";
        vim  = "hx";
        nano = "hx";
        htop = "hx";
        
      };
    };

    # Carapace configuration
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    # Starship configuration
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol   = "[➜](bold red)";
        };
      };
    };

    # GPG configuration
    gpg = {
      enable = true;
      package = pkgs.gnupg;
      settings = {
        trust-model = "tofu+pgp";
      };
    };


    # VS Code configuration
    vscode = {
      enable = true;
    };

    # Oh My Posh configuration
    oh-my-posh = {
      enable = false;
      enableZshIntegration = false;
      enableBashIntegration = false;
    };

    # Home Manager itself
    home-manager = {
      enable = true;
    };
  };

#####################################################
#
#              Services Configuration


 services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-qt; # Instead of pinentryFlavor
      enableExtraSocket = true;
    };
  };
}