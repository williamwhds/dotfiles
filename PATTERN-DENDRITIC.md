## Dendritic Pattern
This configuration uses the **[Dendritic Pattern](https://github.com/mightyiam/dendritic)**.

### How It Works

Every feature file declares an **option** under `options.myModules.nixos.<name>` or `options.myModules.home.<name>` and then **sets** its value under `config.myModules.nixos.<name>`. The host definition (`parts/hosts/t495.nix`) collects the named modules and passes them into `lib.nixosSystem`.

**Key consequences:**
- No fragile relative paths (`../../modules/...`). Files can be moved freely.
- Every file is a flake-parts module — it receives `lib`, `pkgs`, `pkgs-unstable`, `system`, etc.
- Cross-cutting features (like `niri`) handle both NixOS and home-manager in one file.
- Adding a new module = drop a `.nix` file in `modules/` + add its name to the host module list.

### Auto-Import

All `.nix` files under `modules/` are auto-imported by `parts/flake-module.nix`. Files with a `_` prefix in their path are excluded (for private helpers). Non-entry-point files like `disko-config.nix` and `hardware-configuration.nix` live outside `modules/` to avoid auto-import.

---

## Adding a New Module

### NixOS-only Module

Create a `.nix` file anywhere under `modules/`, e.g. `modules/nixos/printing.nix`:

```nix
{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.printing = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.printing = {
    services.printing.enable = true;
    environment.systemPackages = with pkgs; [ system-config-printer ];
  };
}
```

### Home-manager-only Module

```nix
{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.home.git = lib.mkOption { type = types.deferredModule; };

  config.myModules.home.git = {
    programs.git = {
      enable = true;
      userName = "William";
      userEmail = "william@example.com";
    };
  };
}
```

### Cross-cutting Module (NixOS + home-manager)

Put both in one file, e.g. `modules/pipewire.nix`:

```nix
{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules = {
    nixos.pipewire = lib.mkOption { type = types.deferredModule; };
    home.pipewire  = lib.mkOption { type = types.deferredModule; };
  };

  config.myModules = {
    nixos.pipewire = {
      services.pipewire.enable = true;
      services.pipewire.alsa.enable = true;
      security.rtkit.enable = true;
    };
    home.pipewire = {
      # User-level pipewire config, if any
    };
  };
}
```

### When to use a function value (advanced)

If your module references **`config`** (cross-option references) or needs **`pkgs` as resolved by the target evaluator** (NixOS/home-manager rather than flake-parts), make the deferred value a **function**:

```nix
config.myModules.home.noctalia = { config, pkgs, ... }: {
  programs.noctalia-shell.settings.wallpaper.directory =
    "${config.home.homeDirectory}/.dotfiles/home/images/wallpapers";
};
```

```nix
config.myModules.nixos.users = { config, ... }: {
  users.users.williamwhds.hashedPasswordFile =
    config.sops.secrets."williamwhds-password".path;
};
```

This ensures `config` and `pkgs` resolve in the **target evaluation** (NixOS or home-manager), not in the outer flake-parts evaluation.

### Co-locating Insecure Package Exceptions

If a package needs an insecure package exception, put it right next to the package in the same module:

```nix
config.myModules.nixos."packages-utils" = { pkgs, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"  # needed by bitwarden-desktop below
  ];

  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    obsidian
  ];
};
```

Using a function value (`{ pkgs, ... }:`) ensures `nixpkgs.config` is properly applied before `pkgs` is resolved.

---

## Wiring a Module Into a Host

Add its name to the appropriate list in `parts/hosts/t495.nix` (or your host's file):

```nix
nixosModuleNames = [
  "audio"
  "boot"
  "printing"       # <-- add new NixOS module name here
  ...
];

homeModuleNames = [
  "shell"
  "git"            # <-- add new home module name here
  ...
];
```

The name must match the attribute path you used in `options.myModules.nixos.<name>` or `options.myModules.home.<name>`.

---

## Adding a New Host

1. Create `parts/hosts/<name>.nix` (copy `parts/hosts/t495.nix` as a starting point)
2. Create `hosts/<name>/disko-config.nix` and `hosts/<name>/hardware-configuration.nix`
3. Adjust the module name lists for the new host
4. Import the new host in `parts/flake-module.nix`:

```nix
imports = autoModules ++ [
  ./options.nix
  ./hosts/t495.nix
  ./hosts/my-new-host.nix    # <-- add here
];
```

The auto-imported modules under `modules/` are shared across all hosts — each host definition selects which subset to use.

---

## Adding Flake Inputs

Add the input in `flake.nix`, then reference it in any module via `inputs`:

```nix
{ lib, inputs, ... }: {
  # inputs.my-input is available here
}
```

For NixOS or home-manager evaluations that need access to inputs, they are already passed through `specialArgs` / `extraSpecialArgs` in the host definition.

---

## Shared Values (pkgs, pkgs-unstable, system)

These are injected into **every** top-level module via `_module.args` in `parts/options.nix`:

```nix
_module.args = {
  inherit system;
  pkgs = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
};
```

Any module can use `pkgs`, `pkgs-unstable`, or `system` as function arguments without needing `specialArgs` pass-through.

---

## File Naming Convention

| Pattern | Example | Purpose |
|---|---|---|
| `modules/<name>.nix` | `modules/niri.nix` | Cross-cutting or top-level feature |
| `modules/nixos/<name>.nix` | `modules/nixos/audio.nix` | NixOS-only feature |
| `modules/home/<name>.nix` | `modules/home/shell.nix` | Home-manager-only feature |
| `modules/nixos/packages/<name>.nix` | `modules/nixos/packages/gaming.nix` | Package grouping |
| `modules/<name>/default.nix` | `modules/home/mangohud/default.nix` | Module with resource files |
| `_<name>.nix` | excluded from auto-import | Private helpers |
| `parts/` | — | Flake-parts plumbing (not auto-imported) |

---

## Common Pitfalls

| Pitfall | Fix |
|---|---|
| `pkgs` not available | Use `pkgs` from `_module.args` (injected via `parts/options.nix`) |
| `config.sops` not found in module value | Make the deferred value a **function**: `{ config, ... }: { ... }` |
| `lib.hm` not available | `lib.hm` is from home-manager — only usable inside a home-manager module function |
| Module not affecting the build | Did you add its name to `nixosModuleNames` or `homeModuleNames`? |
| File not auto-imported | Is it under `modules/` and not `_`-prefixed? Only `.nix` files are imported. |
| Insecure package error | Co-locate `nixpkgs.config.permittedInsecurePackages` in the same module's function value |
