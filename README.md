# dotfiles

My personal [NixOS](https://nixos.org/) configuration using **flakes**, **disko**, and **home-manager**.

## Hosts
### T495

Boot from a NixOS ISO, then:

```bash
# clone the repo
nix-shell -p git
git clone https://github.com/williamwhds/dotfiles ~/dotfiles
cd ~/dotfiles

# find your disk
ls -l /dev/disk/by-id/

# edit the device path in the disko config to match your disk
# hosts/t495/disko-config.nix → device = "/dev/disk/by-id/YOUR_DISK_ID";
# ⚠️  This wipes the entire disk!

# partition, format, and mount
sudo nix run github:nix-community/disko -- --mode disko ./hosts/t495/disko-config.nix

# generate hardware config
sudo nixos-generate-config --root /mnt

# copy it into the host dir for use during install
cp /mnt/etc/nixos/hardware-configuration.nix ~/dotfiles/hosts/t495/

# install
sudo nixos-install --flake ~/dotfiles#t495

# reboot
sudo reboot
```

## Post-install

On first boot, unlock the LUKS partition and log in. The home-manager activation will clone the repo automatically to `~/.dotfiles` and symlink it to `/etc/nixos`. If that didn't happen:

```bash
git clone https://github.com/williamwhds/dotfiles ~/.dotfiles
```

Then rebuild to activate home-manager and all user configs:

```bash
nh os switch ~/.dotfiles
```
