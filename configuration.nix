# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
    inputs.home-manager.nixosModules.home-manager

    # Neovim, lsp, libs and settings for development
    ./dev-tools.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings = {
    trusted-users = ["@wheel"];

    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.optimise = {
    automatic = true;
    dates = "daily";
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
    };
  };

  # Use zen kernel.
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  # DBus service that allows applications to query and manipulate storage devices.
  services.udisks2.enable = true;

  networking.hostName = "pablo-nixos";

  # Additional hosts entries.
  networking.hosts = {
    "127.0.0.1" = ["pablohez.dev"];
  };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Bogota";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # mpris media player command-line controller
  services.playerctld.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pablo = {
    isNormalUser = true;
    initialPassword = "password";

    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker" # Use docker without sudo
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.pablo = import ./home/pablo.nix;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    tree # Depth indented directory listing
    kitty # Terminal emulator
    wget # Tool for retrieving files using HTTP, HTTPS, and FTP
    dunst # Notification daemon
    hyprpolkitagent # Authentication agent
    ashell # Status bar
    wl-clipboard # Copy/paste utility
    cliphist # Clipboard manager
    fuzzel # App launcher
    app2unit # Launches Desktop Entries as Systemd user units
    inputs.zen-browser.packages."${system}".beta # Zen-browser
    lutris # Game launcher
    heroic # Game launcher
    itch # Game store
    protonup-rs # Install and update GE-Proton for Steam, and Wine-GE for Lutris
    steam-run # FHS environment
    qimgv # Image viewer
    vlc # Media player
    zathura # Pdf reader
    unzip # Extraction utility
    inputs.rose-pine-hyprcursor.packages.${system}.default # Rose pine cursor theme
    grim # Grab images from a Wayland compositor
    slurp # Select a region in a Wayland compositor
  ];

  environment.shellAliases = {
    cd = "z"; # Use zoxide instead of just cd
    y = "yazi"; # Shortcut
  };

  programs.gamemode.enable = true;
  programs.steam.enable = true;

  programs.bash = {
    enable = true;
  };

  programs.zoxide.enable = true;

  programs.git.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 3";
    flake = "/home/pablo/.config/nixos/";
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      crimson-pro
      noto-fonts
      nerd-fonts.jetbrains-mono
      corefonts
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Crimson Pro"
        ];
        sansSerif = [
          "Noto Sans"
        ];
        monospace = ["JetBrains Mono"];
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  programs.ssh.startAgent = true;

  services.displayManager.ly = {
    enable = true;
  };

  systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";

  # Docker
  virtualisation = {
    docker.enable = true;

    vmVariant = {
      virtualisation = {
        memorySize = 2048;
        cores = 3;
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  xdg.mime = let
    value = let
      zen-browser = inputs.zen-browser.packages.${system}.beta; # or twilight
    in
      zen-browser.meta.desktopFileName;

    associations = builtins.listToAttrs (
      map
      (name: {
        inherit name value;
      })
      [
        "application/x-extension-shtml"
        "application/x-extension-xhtml"
        "application/x-extension-html"
        "application/x-extension-xht"
        "application/x-extension-htm"
        "x-scheme-handler/unknown"
        "x-scheme-handler/mailto"
        "x-scheme-handler/chrome"
        "x-scheme-handler/about"
        "x-scheme-handler/https"
        "x-scheme-handler/http"
        "application/xhtml+xml"
        "application/json"
        "text/plain"
        "text/html"
      ]
    );
  in {
    addedAssociations = associations;
    defaultApplications = associations;
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      }
    ];
  };

  programs.yazi = {
    enable = true;
    plugins = with pkgs.yaziPlugins; {
      mount = mount;
      chmod = chmod;
      smart-paste = smart-paste;
    };
    settings = {
      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = "M";
              run = "plugin mount";
              desc = "Open mount menu";
            }
            {
              on = "p";
              run = "plugin smart-paste";
              desc = "Paste into the hovered directory or CWD";
            }
            {
              on = [
                "c"
                "m"
              ];
              run = "plugin chmod";
              desc = "Chmod on selected files";
            }
          ];
        };
      };
    };
  };

  programs.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "app2unit kitty";
      "$browser" = "app2unit zen-beta";
      "$menu" = "fuzzel --launch-prefix='app2unit --fuzzel-compat --'";

      env = [
        "TERMINAL=kitty"
        "HYPRCURSOR_THEME=rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE=24"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];

      exec-once = [
        "ashell &"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      general = {
        border_size = 1;
        resize_on_border = true;
      };

      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
      };

      workspace = [
        # No gaps when there is a single window
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

      decoration = {
        dim_inactive = true;
        dim_strength = 0.06;
      };

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bind =
        [
          "$mod, z, exec, $browser"
          "$mod, m, exec, $menu"
          "$mod, t, exec, $terminal"
          "$mod, q, killactive,"
          "$mod, V, exec, cliphist list | fuzzel --dmenu --with-nth 2 | cliphist decode | wl-copy"

          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"

          "$mod Shift, h, movewindow, l"
          "$mod Shift, j, movewindow, d"
          "$mod Shift, k, movewindow, u"
          "$mod Shift, l, movewindow, r"

          "$mod Alt, h, resizeactive, -25 0"
          "$mod Alt, j, resizeactive, 0 25"
          "$mod Alt, k, resizeactive, 0 -25"
          "$mod Alt, l, resizeactive, 25 0"

          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          "$mod, [, exec, hyprctl keyword general:layout 'dwindle'"
          "$mod, ], exec, hyprctl keyword general:layout 'master'"

          # Screenshots
          ", Print, exec, grim -g \"$(slurp -d)\" - | wl-copy"
          "Shift, Print, exec, grim -g \"$(slurp)\""
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i: let
              ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9
        ));
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
