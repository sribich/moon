# TODO: Make this more modular using multiple flake imports in envrc
#       https://github.com/the-nix-way/dev-templates/blob/main/rust/flake.nix
#       https://determinate.systems/posts/nix-direnv/

{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = inputs @ { self, fenix, nixpkgs }: let
    system = "x86_64-linux";

    rustToolchain = fenix.packages.${system}.minimal.toolchain;
    rustPlatform = pkgs.makeRustPlatform {
      cargo = rustToolchain;
      rustc = rustToolchain;
    };

    mkPkgs = system:
      import inputs.nixpkgs {
        inherit system;
        overlays = [
          fenix.overlays.default
        ];
      };

    pkgs = mkPkgs system;
  in {
    devShells.${system}.default = pkgs.mkShell {
      NIX_LD= "${pkgs.stdenv.cc.libc}/lib/ld-linux-x86-64.so.2";

      packages = with pkgs; [
        (pkgs.fenix.complete.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
          "llvm-tools-preview"
          "rustc-codegen-cranelift-preview"
          "miri"
        ])
        rust-analyzer-nightly
        cargo-llvm-cov
        cargo-nextest
        cargo-mutants
        cargo-watch
        cargo-audit
        cargo-deny
        cargo-geiger
        cargo-outdated
        cargo-insta
        cargo-hack
        grcov
        bunyan-rs
        valgrind
        cargo-valgrind
      ];
      buildInputs = with pkgs; [
      ];

      shellHook = let
        libraries = with pkgs; [

        ];
      in ''

      '';
    };
  };
}

# export CUDA_PATH=${pkgs.cudatoolkit}
        # export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
        # export EXTRA_CCFLAGS="-I/usr/include"
        # webkitgtk 2.42 has problems with with nvidia drivers
