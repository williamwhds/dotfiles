{ lib, ... }:
let
  # auto-import all .nix files under ../modules/
  # every .nix file is a top-level flake-parts module, except:
  #   - files inside a path with "/_" prefix (private helpers)
  #   - non-module resource files (non-.nix)
  modulesDir = ../modules;
  allFiles = lib.filesystem.listFilesRecursive modulesDir;

  isModule =
    p:
    let
      s = toString p;
    in
    lib.strings.hasSuffix ".nix" s && !lib.hasInfix "/_" s;

  autoModules = builtins.filter isModule allFiles;
in
{
  imports = autoModules ++ [
    ./options.nix
    ./hosts/t495.nix
  ];

  perSystem = { ... }: { };
}
