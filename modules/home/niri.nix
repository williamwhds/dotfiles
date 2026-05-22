{ ... }:

{
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
        matches = [ { app-id = "^foot$"; } ];
        open-floating = true;
      }
    ];

    spawn-at-startup = [
      # { argv = ["awww-daemon"];} --- using noctalia's wallpaper manager. Might want to switch back later tho
      # { argv = ["awww" "img" "~/.dotfiles/home/images/wallpapers/splatoon-wallpaper.png"];}

      {
        command = [ "noctalia-shell" ];
      }
    ];

    binds = {
      # --- Applications, Commands and Shells ---
      "Mod+T".action.spawn = "foot";

      "Mod+Shift+S".action.screenshot = { };
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

      "Mod+Left".action.focus-column-or-monitor-left = { };
      "Mod+Down".action.focus-window-or-workspace-down = { };
      "Mod+Up".action.focus-window-or-workspace-up = { };
      "Mod+Right".action.focus-column-or-monitor-right = { };

      "Mod+Shift+Left".action.move-column-left-or-to-monitor-left = { };
      "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = { };
      "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = { };
      "Mod+Shift+Right".action.move-column-right-or-to-monitor-right = { };

      "Mod+Q".action.close-window = { };

      "Mod+Space".action.toggle-overview = { };

      "Mod+F".action.maximize-column = { };
      "Mod+Shift+F".action.fullscreen-window = { };

      "Mod+V".action.toggle-window-floating = { };
      "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };

      # not really useful, so I might rebind R to something else later
      "Mod+R".action.switch-preset-column-width = { };
      "Mod+Shift+R".action.switch-preset-window-height = { };
    };
  };
}
