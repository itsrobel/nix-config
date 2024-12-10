# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./home.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = ["snd-intel-dspcfg.dsp_driver=1"];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
	enable = true;
  };
  services = {
	displayManager = {
		  sddm.enable = true;
	};
  };
  services.xserver.windowManager.awesome = {
  enable = true;
  luaModules = with pkgs.luaPackages ; [
      luarocks
      luadbi-mysql
    ];
  };



  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.gnome.gnome-keyring.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stef = {
    isNormalUser = true;
    description = "stef";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };
  programs.light.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  programs.sway = {
  	enable = true;
	wrapperFeatures.gtk = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "Meslo" ]; })
];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
  wl-clipboard
  mako
  slurp
  grim
  alsa-firmware
  alsa-oss
  alsa-lib
  alsa-utils
  alsa-tools
  pipewire
  jack2
  pulseaudio
  git
  wezterm
  wofi
  obsidian
  spotify
  discord
  neovim
  fastfetch
  zsh
  tmux
  brave
  stow
  zig
  gcc
  kitty
  zoxide
  zathura
  eza
  fzf
  python3
  nodejs_22
  luarocks
  lua
  php
  zulu
  go
  julia
  python311Packages.pip
  cargo
  tree-sitter
  ruby
  lua51Packages.tl
  ripgrep
  lazygit
  fd
  texlivePackages.latexmk
  biber
  texlivePackages.bibtex
  clang
  waybar
  firefox
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
