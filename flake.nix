{
  description = "flutter background + bar";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    dart-flutter,
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
          dart-flutter.overlays.default
        ];
      };
    in {
      packages = {
        inherit (pkgs) flutter-background-bar;
        default = pkgs.flutter-background-bar;
      };
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          flutter
          pkg-config
          cmake
          ninja
          clang
        ];
        buildInputs = with pkgs; [
          gtk-layer-shell
          cava

          atk
          cairo
          gdk-pixbuf
          glib
          gtk3
          harfbuzz
          libepoxy
          pango
          xorg.libX11
          libdeflate
        ];
      };
    })
    // {
      overlays.default = _final: prev: let
        pkgs = import nixpkgs {
          inherit (prev) system;
          overlays = [dart-flutter.overlays.default];
        };
      in {
        flutter-background-bar = pkgs.callPackage ./nix/package.nix {};
      };
    };
}
