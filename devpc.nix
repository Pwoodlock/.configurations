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
  home.stateVersion = "24.05";  # Please read the comment before changing

  # Packages to install in the user's environment
  home.packages = [
    pkgs.oh-my-posh
    pkgs.waveterm
    pkgs.microsoft-edge
    pkgs.ungoogled-chromium
    pkgs.lutris
    pkgs.nextcloud-client
    pkgs.nushell
    pkgs.starship
    pkgs.carapace
    pkgs.vscode
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

  #####################################################
  # Terminal-related Configuration
  #####################################################

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
      };
    };

    # Carapace (completion framework) configuration
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    # Starship prompt configuration
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
  };

  #####################################################
  # Additional program configurations
  #####################################################

  # Enable Visual Studio Code and Oh My Posh
  programs.vscode.enable = true;
  programs.oh-my-posh.enable = true;
  programs.oh-my-posh.enableZshIntegration = true;
  programs.oh-my-posh.enableBashIntegration = true;

  # Enable Home Manager itself
  programs.home-manager.enable = true;
}
