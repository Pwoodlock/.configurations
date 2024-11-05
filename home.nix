{ config, pkgs, ... }:


####################################################
#
# Section for setting up variables
#


let
  myAliases = {
  ll = "ls -l";
  ".." = "cd ..";
  };

in

#####################################################
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nixos-dd";
  home.homeDirectory = "/home/nixos-dd";
  nixpkgs.config.allowUnfree = true;


  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [

    pkgs.vscode
    pkgs.oh-my-posh
    pkgs.whatsapp-for-linux
    pkgs.freecad-wayland
    pkgs.flatpak
    pkgs.waveterm
    pkgs.stremio



    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nixos-dd/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };



  # **** Terminal Related
  # The below is to enable the type of Bash and Aliases to the home-manager directory.  
  programs.bash = {
    enable = true;
    shellAliases = myAliases;

  };

  programs.zsh = {
    enable = true;
    shellAliases = myAliases;

  };

  programs.git = {
    enable = true;
    userName = "PWoodlock";
    userEmail = "patrick@devsec.ie";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  #******** Services & Programs Section
  programs.vscode.enable = true;
  programs.oh-my-posh.enable = true;
  programs.oh-my-posh.enableZshIntegration = true;
  programs.oh-my-posh.enableBashIntegration = true;
  #services.flatpak.enable = true;
  #programs.freecad-wayland.enable = true;
 

  







  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
