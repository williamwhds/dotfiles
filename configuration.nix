{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko-config.nix
    inputs.disko.nixosModules.disko
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # old bootloader stuff, move this somewhere else later
  #boot.loader.systemd-boot.enable = false;
  #boot.loader.efi.canTouchEfiVariables = false;

  #boot.loader.grub = {
  #  enable = true;
  #  efiSupport = true;
  #  efiInstallAsRemovable = true;
  #  device = "nodev";
  #};

  #boot.initrd.availableKernelModules = [
  #  "xhci_pci"
  #  "ehci_pci"
  #  "ahci"
  #  "usb_storage"
  # "uas"
  # "sd_mod"
  #  "sr_mod"
  #];

  # save space by hardlinking identical files in the Nix store
  nix.settings.auto-optimise-store = true;

  # automatically clear NixOS generations older than 14 days
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  services.sanoid = {
    enable = true;
    interval = "daily";

    datasets = {
      "btrfs/root" = {
        useTemplate = [ "7day-rolling" ];
      };
      "btrfs/home" = {
        useTemplate = [ "7day-rolling" ];
      };
    };

    templates = {
      "7day-rolling" = {
        daily = 7; # keep exactly 7 days of snapshots
        hourly = 0;
        weekly = 0;
        monthly = 0;
        yearly = 0;
        autoprune = true; # automatically deletes the 8th day snapshot
        autosnap = true; # automatically takes the new snapshot daily
      };
    };
  };

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # zram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";
  # boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # tlp - power management
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      # battery thresholds
      START_CHARGE_THRESH_BAT0 = 50;
      STOP_CHARGE_THRESH_BAT0 = 70;
    };
  };

  # Enable battery status
  services.upower.enable = true;

  # Set your time zone.
  time.timeZone = "America/Bahia";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_CTYPE = "pt_BR.UTF-8"; # fix ç in us-intl. thanks, kokada
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  programs.xwayland.enable = true; # allows X11 apps to run inside Wayland
  programs.zsh.enable = true; # enabling Zsh

  services.flatpak.enable = true; # enabling Flatpak

  services.fprintd.enable = true; # fingerprint scanner service
  security.pam.services.sudo.fprintAuth = true; # fingerprint for auth sudo in terminal
  security.pam.services.login.fprintAuth = false; # disable for SDDM
  security.pam.services.login.enableKwallet = true; # disable kwallet password prompt

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
  users.users.williamwhds = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "William Oliveira";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git # version control
    gh # github-cli
    curl # web requests
    wget # web requests
    ghostty # terminal
    foot # backup terminal
    fastfetch # le cool ascii art
    zed-editor # text editor
    neovim # text editor
    btop # system monitor
    floorp-bin # web browser
    obsidian # note-taking
    kdePackages.kdenlive # video editor
    vesktop # discord client

    # this is getting crowded, I'm modularizing it later
    nil # Nix Language Server
    nixd # Nix Daemon
    nodePackages.vscode-langservers-extracted # vscode language servers
    package-version-server # package version server for vscode language servers

    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww # wallpaper manager
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default # noctalia
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # enable the OpenSSH daemon
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22 # ssh
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
