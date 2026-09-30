{ lib, ... }:
let
  inherit (lib) types;
in
{
  # ai generated this so I could have a quick fix
  # this probably doesn't work properly
  # there's probably a better way

  options.myModules.nixos."card-reader" = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos."card-reader" =
    { pkgs, ... }:
    {
      # Keep Realtek RTS522A controller awake so insertion interrupts are detected
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10ec", ATTR{device}=="0x522a", ATTR{power/control}="on"
      '';

      # TLP runtime power management fixes:
      # - RUNTIME_PM_DRIVER_DENYLIST prevents TLP from touching rtsx_pci devices
      # - RUNTIME_PM_DISABLE and RUNTIME_PM_DENYLIST use PCI bus address (05:00.0) to force power/control="on"
      services.tlp.settings = {
        RUNTIME_PM_DRIVER_DENYLIST = "mei_me nouveau radeon xhci_hcd rtsx_pci";
        RUNTIME_PM_DENYLIST = "05:00.0";
        RUNTIME_PM_DISABLE = "05:00.0";
      };

      # The ThinkPad T495 motherboard cuts PCIe power to the Realtek RTS522A during S3 sleep,
      # which power-cycles the SD card. Leaving filesystems mounted across S3 power-loss causes
      # corrupted states and frozen I/O calls.
      #
      # Solution:
      # 1. Before sleep: flush writes, record active mmc mounts, and cleanly unmount.
      # 2. On resume: reload rtsx_pci modules and restore previous mounts.
      powerManagement.powerDownCommands = ''
        ${pkgs.coreutils}/bin/sync
        rm -f /run/mmc-sleep-mounts
        for dev in $(${pkgs.gawk}/bin/awk '$1 ~ /^\/dev\/mmcblk/ { print $1 }' /proc/mounts | sort -u); do
          uuid=$(${pkgs.util-linux}/bin/blkid -s UUID -o value "$dev" 2>/dev/null || true)
          mnt=$(${pkgs.gawk}/bin/awk -v d="$dev" '$1 == d { print $2; exit }' /proc/mounts)
          if [ -n "$uuid" ] && [ -n "$mnt" ]; then
            echo "$uuid $mnt" >> /run/mmc-sleep-mounts
          fi
          ${pkgs.udisks2}/bin/udisksctl unmount -b "$dev" --no-user-interaction 2>/dev/null || \
            ${pkgs.util-linux}/bin/umount "$dev" 2>/dev/null || true
        done
        ${pkgs.coreutils}/bin/sync
      '';

      powerManagement.resumeCommands = ''
        ${pkgs.kmod}/bin/modprobe -r rtsx_pci_sdmmc rtsx_pci 2>/dev/null || true
        ${pkgs.kmod}/bin/modprobe rtsx_pci_sdmmc 2>/dev/null || true

        if [ -s /run/mmc-sleep-mounts ]; then
          # Wait up to 3 seconds for /dev/disk/by-uuid entries to appear
          for i in $(${pkgs.coreutils}/bin/seq 1 30); do
            all_ready=true
            while read -r uuid mnt; do
              if [ ! -e "/dev/disk/by-uuid/$uuid" ]; then
                all_ready=false
              fi
            done < /run/mmc-sleep-mounts
            if [ "$all_ready" = "true" ]; then
              break
            fi
            ${pkgs.coreutils}/bin/sleep 0.1
          done

          while read -r uuid mnt; do
            dev="/dev/disk/by-uuid/$uuid"
            if [ -e "$dev" ]; then
              case "$mnt" in
                /run/media/*/*)
                  user=$(echo "$mnt" | cut -d/ -f4)
                  uid=$(${pkgs.coreutils}/bin/id -u "$user" 2>/dev/null || true)
                  if [ -n "$uid" ] && [ -d "/run/user/$uid" ]; then
                    ${pkgs.util-linux}/bin/su - "$user" -c \
                      "XDG_RUNTIME_DIR=/run/user/$uid DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus ${pkgs.udisks2}/bin/udisksctl mount -b '$dev' --no-user-interaction" \
                      2>/dev/null || true
                  else
                    ${pkgs.util-linux}/bin/mount "$dev" "$mnt" 2>/dev/null || true
                  fi
                  ;;
                *)
                  ${pkgs.util-linux}/bin/mount "$dev" "$mnt" 2>/dev/null || true
                  ;;
              esac
            fi
          done < /run/mmc-sleep-mounts
          rm -f /run/mmc-sleep-mounts
        fi
      '';
    };
}
