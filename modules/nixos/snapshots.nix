{ ... }:

{
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
}
