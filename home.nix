{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default # now we can edit noctalia in this file
  ];

  home.username = "williamwhds";
  home.homeDirectory = "/home/williamwhds";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

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

  home.file =
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    builtins.mapAttrs (key: value: {
      # setting symlinks outside of Nix Store, this way I don't need to rebuild the config everytime I change these files
      # symlink ~/.dotfiles/{value} to ~/{key}
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/${value}";
    }) {
      ".config/nvim" = "home/config/nvim";
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
  #  /etc/profiles/per-user/williamwhds/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # niri configs
  programs.niri.settings = {
    layout = {
      gaps = 16;
      center-focused-column = "never";
      focus-ring = {
        active.color = "#a35ce6";
        enable = true;
        width = 4;
      };
    };

    window-rules = [
      {
        # Round corners for all windows
        geometry-corner-radius = {
          top-left = 10.0;
          top-right = 10.0;
          bottom-left = 10.0;
          bottom-right = 10.0;
        };
        clip-to-geometry = true;
      }

      {
        matches = [{app-id = "^foot$";}];
        open-floating = true;
      }
    ];

    spawn-at-startup = [
      # { argv = ["awww-daemon"];} --- using noctalia's wallpaper manager. Might want to switch back later tho
      # { argv = ["awww" "img" "~/.dotfiles/home/images/wallpapers/splatoon-wallpaper.png"];}

      {
        command = ["noctalia-shell"];
      }
    ];

    binds = {
      # --- Applications, Commands and Shells ---
      "Mod+T".action.spawn = "foot";

      "Mod+Shift+S".action.screenshot = {};
      "Mod+Return".action.spawn-sh = "noctalia-shell ipc call launcher toggle"; # Noctalia app launcher
      "Mod+C".action.spawn-sh = "noctalia-shell ipc call launcher clipboard"; # Noctalia clipboard
      "Mod+Shift+Backspace".action.spawn-sh = "noctalia-shell ipc call sessionMenu toggle"; # Noctalia session menu

      # --- Workspace and Windows ---
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;

      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;

      "Mod+Left".action.focus-column-or-monitor-left = {};
      "Mod+Down".action.focus-window-or-workspace-down = {};
      "Mod+Up".action.focus-window-or-workspace-up = {};
      "Mod+Right".action.focus-column-or-monitor-right = {};

      "Mod+Shift+Left".action.move-column-left-or-to-monitor-left = {};
      "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = {};
      "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = {};
      "Mod+Shift+Right".action.move-column-right-or-to-monitor-right = {};

      "Mod+Q".action.close-window = {};

      "Mod+Space".action.toggle-overview = {};

      "Mod+F".action.maximize-column = {};
      "Mod+Shift+F".action.fullscreen-window = {};

      "Mod+V".action.toggle-window-floating = {};
      "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};

      # not really useful, so I might rebind R to something else later
      "Mod+R".action.switch-preset-column-width = {};
      "Mod+Shift+R".action.switch-preset-window-height = {};
    };
  };

  # my shell
  programs.zsh = {
    enable = true;
    oh-my-zsh.enable = true;
    oh-my-zsh.theme = "gnzh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      sops-edit = "SOPS_AGE_KEY_FILE=~/.dotfiles/secret-key.txt sops ~/.dotfiles/secrets/secrets.yaml";
    };
  };

  # noctalia
  programs.noctalia-shell = {
    enable = true;
    settings = {
      # configure noctalia here
      bar = {
        density = "mini";
        position = "top";
        barType = "mini";
        showCapsule = false;
        marginVertical = 0;
        marginHorizontal = 4;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }

            {
              id = "SystemMonitor";
            }

            {
              id = "MediaMini";
            }
          ];

          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];

          right = [
            {
              id = "Tray";
            }

            {
              id = "NotificationHistory";
            }

            {
              id = "KeyboardLayout";
            }

            {
              id = "Volume";
            }

            {
              id = "Network";
            }

            {
              id = "Bluetooth";
            }

            {
              id = "Battery";
              alwaysShowPercentage = false;
              warningThreshold = 30;
            }

            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };

      dock = {
        enable = true;
        position = "bottom";
        displayMode = "auto_hide";
        dockType = "floating";
        pinnedStatic = true;
      };

      appLauncher = {
        enableClipboardHistory = true;
      };

      wallpaper = {
        enabled = true; # check this later, I might want to replace awww manager with noctalia's
        transitionType = [
          "stripes"
          "wipe"
        ];
        directory = "${config.home.homeDirectory}/.dotfiles/home/images/wallpapers";
      };

      colorSchemes.predefinedScheme = "Gruvbox";
      general = {
        # avatarImage = "/home/drfoobar/.face";
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = false;
        name = "Porto Seguro, Brazil";
      };
    };
    # this may also be a string or a path to a JSON file.
  };

  # home-manager itself
  programs.home-manager.enable = true;
}
