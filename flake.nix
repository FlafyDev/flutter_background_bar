{
  description = "flutter background + bar";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
          (_final: prev: {
            gtk3 = prev.gtk3.overrideAttrs (_old: {
              src = prev.fetchgit {
                url = "https://gitlab.gnome.org/GNOME/gtk";
                rev = "b05ade591b98842ef5850eb04331ab55da504d7f"; # Latest in refs/heads/gtk-3-24
                sha256 = "sha256-5p7hOj8OmejMG12swwuyNTBHzSdWTUfn4VE/qy9Ge/c=";
              };
            });
          })
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
        ];
        buildInputs = with pkgs; [
          gtk-layer-shell
          cava
          # atk
          # cairo
          # gdk-pixbuf
          # glib
          # gtk3
          # harfbuzz
          # libepoxy
          # pango
          # xorg.libX11
          # libdeflate
        ];
      };
    })
    // {
      overlays.default = _final: prev: {
        flutter-background-bar = prev.callPackage ./nix/package.nix {};
      };
    };
}
