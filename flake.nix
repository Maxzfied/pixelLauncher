{
  description = "Prism Launcher fork aimed to provide a free way to play Minecraft.";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://freesmlauncher.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "freesmlauncher.cachix.org-1:Jcp5Q9wiLL+EDv8Mh7c6L9xGk+lXr7/otpKxMOuBuDs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-filter.url = "github:numtide/nix-filter";
    libnbtplusplus = {
      url = "github:FreesmTeam/libnbtplusplus";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-filter,
    libnbtplusplus,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forEachSystem = nixpkgs.lib.genAttrs systems;

    mkJvmPack = pkgs: let
      openjdk = with pkgs; [
        openjdk8
        openjdk17
        openjdk21
        openjdk25
      ];

      temurin = with pkgs.javaPackages.compiler.temurin-bin; [
        jdk-8
        jdk-17
        jdk-21
        jdk-25
      ];

      corretto = with pkgs.javaPackages.compiler; [
        corretto17
        corretto21
        corretto25
      ];

      graal-ce = with pkgs.graalvmPackages; [
        graalvm-ce
      ];

      graal-unfree = with pkgs.graalvmPackages; [
        graalvm-oracle_17
        graalvm-oracle_25
      ];
    in {
      inherit openjdk temurin corretto graal-ce graal-unfree;
      allPack = openjdk ++ temurin ++ corretto ++ graal-ce ++ graal-unfree;
    };
  in {
    overlays.default = final: prev: {
      pixellauncher-unwrapped = final.callPackage ./nix/unwrapped.nix {
        inherit nix-filter libnbtplusplus self;
      };

      pixellauncher = final.callPackage ./nix/wrapper.nix {
        jvmPack = mkJvmPack final;
      };
    };

    packages = forEachSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      jvmPack = mkJvmPack pkgs;

      pixellauncher-unwrapped = pkgs.callPackage ./nix/unwrapped.nix {
        inherit nix-filter libnbtplusplus self;
      };

      pixellauncher = pkgs.callPackage ./nix/wrapper.nix {
        inherit pixellauncher-unwrapped jvmPack;
      };

      pixellauncher-unwrapped-debug = pixellauncher-unwrapped.overrideAttrs {
        cmakeBuildType = "Debug";
        dontStrip = true;
      };

      pixellauncher-debug = pkgs.callPackage ./nix/wrapper.nix {
        pixellauncher-unwrapped = pixellauncher-unwrapped-debug;
      };
    in {
      inherit pixellauncher pixellauncher-unwrapped pixellauncher-debug pixellauncher-unwrapped-debug jvmPack;

      default = pixellauncher;
    });

    devShells = forEachSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [self.overlays.default];
      };
    in {
      default = pkgs.mkShell {
        inputsFrom = [pkgs.pixellauncher-unwrapped];

        packages = with pkgs; [
          ccache
          ninja
        ];
      };
    });

    formatter = forEachSystem (
      system:
        (import nixpkgs {inherit system;}).alejandra
    );
  };
}
