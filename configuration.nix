# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;




  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  
  users.users.nixos-dd = {
    isNormalUser = true;
    description = "Patrick Woodlock";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    packages = with pkgs; [

      kdePackages.kate
      thunderbird
      vorta
      

    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = false;
  services.xserver.displayManager.autoLogin.user = "nixos-dd";

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    curl
    htop
    zsh
    kdePackages.karousel
    vmware-workstation
    open-vm-tools
    borgbackup 
    borgmatic
    kdePackages.full
    kdePackages.discover
    kdePackages.plasma-workspace-wallpapers
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ] ;
  nix.settings.download-buffer-size = 500000000;

  #**** SERVICES *****
  services.netbird.enable = true;
  services.flatpak.enable = true;

  #**** Environment Shells 
  environment.shells = with pkgs; [ nushell ];
  users.defaultUserShell = pkgs.nushell;
  programs.zsh.enable = false;


  #**** PROGRAMS *****
  programs.thunderbird.enable = true;
  programs.kdeconnect.enable = true;
  programs.appimage.enable = true;



  # VMware Workstation criteria
  virtualisation.vmware.host.enable = true;
  boot.kernelModules = [
    "vmmon"  # VMware Monitor
    "vmnet"  # VMware Network
  ];  # Close the kernelModules list here





  # Borgmatic Configuration
  #
  # Enable the borgmatic service
  services.borgmatic = {
    enable = true;
    configurations = {
      main = {
        source_directories = [
          "/home/nixos-dd/Documents"
        ];
        repositories = [
          {
            path = "ssh://h2bu90a2@h2bu90a2.repo.borgbase.com/./repo";
            label = "borgbase";
          }
        ];
        storage = {
          encryption_passcommand = "cat /home/nixos-dd/.ssh/borgbase/nixos-dd/passphrase";
          ssh_command = "ssh -i /home/nixos-dd/.ssh/borgbase/nixos-dd/borg-nixos-dd";
          compression = "lzma";
        };
        retention = {
          keep_daily = 7;
          keep_weekly = 4;
          keep_monthly = 2;
        };
        consistency = {
          checks = [
            { name = "repository"; frequency = "2 weeks"; }
            { name = "archives"; frequency = "4 weeks"; }
          ];
          check_last = 3;
        };
        hooks = {
          before_backup = [
            "echo 'Starting backup' >> /var/log/borgmatic.log"
          ];
          after_backup = [
            "echo 'Backup complete' >> /var/log/borgmatic.log"
          ];
        };
      };
    };
  };

  # Configure the systemd timer for borgmatic
  systemd.timers.borgmatic = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
