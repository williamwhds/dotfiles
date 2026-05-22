{ ... }:

{
  programs.plasma = {
    enable = true;
    overrideConfig = true;

    # dark theme
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    configFile = {
      # trackpad
      "kcminputrc" = {
        "Libinput/2/7/SynPS\\/2 Synaptics TouchPad" = {
          PointerAcceleration = 0.400;
          PointerAccelerationProfile = 1;
        };
      };

      # accessibility
      "kwinrc" = {
        "Plugins" = {
          "shakecursorEnabled" = false;
        };
      };

      # prevent Plasma from mounting every device when plugged in
      "kded5rc" = {
        "Module-device_automounter" = {
          autoload = false;
        };
      };
    };

    panels = [
      # TOP PANEL
      {
        location = "top";
        height = 30;
        hiding = "dodgewindows";
        lengthMode = "fill";

        widgets = [
          "org.kde.plasma.showdesktop"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.pager"
          "org.kde.plasma.marginsseparator"

          "org.kde.plasma.systemmonitor.cpu"
          "org.kde.plasma.systemmonitor.memory"
          "org.kde.plasma.systemmonitor.net"

          "org.kde.plasma.panelspacer"

          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              date = {
                enable = true;
                position = "besideTime";
                format.custom = "ddd d |";
              };
              time = {
                format = "24h";
                showSeconds = "onlyInTooltip";
              };
            };
          }

          "org.kde.plasma.panelspacer"

          "org.kde.plasma.systemtray"
        ];
      }

      # BOTTOM PANEL
      {
        location = "bottom";
        height = 40;
        hiding = "autohide";
        lengthMode = "fit";

        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake-white";
              };
            };
          }
          "org.kde.plasma.marginsseparator"
          {
            iconTasks = {
              launchers = [
                "applications:systemsettings.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:app.zen_browser.zen.desktop"
              ];
            };
          }
        ];
      }
    ];
  };
}
