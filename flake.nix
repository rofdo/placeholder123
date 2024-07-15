{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default = with pkgs; mkShell {
          buildInputs = [
            systemd
            alsa-lib
            (rust-bin.beta.latest.default.override { targets = ["wasm32-unknown-unknown"]; })
            wayland
            libxkbcommon
            xorg.libX11
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXi
            libglvnd
            cmake
            vulkan-tools
            vulkan-headers
            vulkan-loader
            vulkan-validation-layers
            pkg-config 
            libGL
            trunk
          ];

          LD_LIBRARY_PATH="${pkgs.wayland}/lib:${pkgs.libxkbcommon}/lib:${pkgs.xorg.libX11}/lib:${pkgs.xorg.libXcursor}/lib:${pkgs.xorg.libXrandr}/lib:${pkgs.xorg.libXi}/lib:${pkgs.libglvnd}/lib:${pkgs.libglvnd}/lib:${pkgs.libglvnd}/lib:${pkgs.cmake}/lib:${pkgs.vulkan-tools}/lib:${pkgs.vulkan-headers}/lib:${pkgs.vulkan-loader}/lib:${pkgs.vulkan-validation-layers}/lib:${pkgs.libGL}/lib:${pkgs.trunk-ng}/lib:$LD_LIBRARY_PATH";

          # alias trunk-ng to trunk
          # shellHook = ''
            # alias trunk=trunk-ng
          # '';
        };
      }
    );
}
