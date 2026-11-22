# NixOS

> [!IMPORTANT]
> We use **Garnix CI** for binary caching.
> To configure the cache manually, follow the official guide:
>
> - [Garnix binary cache guide](https://garnix.io/docs/ci/caching)
>
> We also provide a secondary cache through [**Cachix**](https://app.cachix.org/cache/freesmlauncher#pull).
> Additional information is available in the official
> [Cachix getting started guide](https://docs.cachix.org/getting-started#using-binaries-with-nix).

<div align="center">

# Running and installing on NixOS

This guide explains how to run and install **PixelLauncher** on NixOS.

</div>

## Running without installation

```fish
nix run github:YOUR_GITHUB_USER/PixelLauncher#pixellauncher
```

## Installation

Add the flake input to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pixellauncher = {
      url = "github:YOUR_GITHUB_USER/PixelLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, pixellauncher, ... }: {
    # your outputs
  };
}
```

### NixOS configuration

```nix
{ pkgs, system, pixellauncher, ... }:

{
  environment.systemPackages = [
    pixellauncher.packages.${system}.pixellauncher
  ];
}
```

### Home Manager configuration

```nix
{ pkgs, system, pixellauncher, ... }:

{
  home.packages = [
    pixellauncher.packages.${system}.pixellauncher
  ];
}
```

## Updating

To update the flake input:

```fish
nix flake update pixellauncher
```

Or update all inputs:

```fish
nix flake update
```
