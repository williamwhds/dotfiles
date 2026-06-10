{ config, ... }:

{
  programs.noctalia = {
    enable = true;
    settings = {
      bar = {
        density = "mini";
        position = "top";
        barType = "floating";
        showCapsule = false;
        marginVertical = 0;
        marginHorizontal = 8;
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
        enable = true; # check this later, I might want to replace awww manager with noctalia's
        transitionType = [
          "stripes"
          "wipe"
        ];
        directory = "${config.home.homeDirectory}/.dotfiles/home/images/wallpapers";
      };

      colorSchemes.predefinedScheme = "Gruvbox";

      general = {
        avatarImage = "${config.home.homeDirectory}/.dotfiles/home/images/profile/gappy.png";
        radiusRatio = 0.2;
      };

      location = {
        monthBeforeDay = false;
        name = "Porto Seguro, Brazil";
      };
    };
  };
}
