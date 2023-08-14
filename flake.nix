{
  description = "flutter background + bar";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/962cc00249dd42d748d9b9e7109521978aab8a48";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = let in {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
          (final: prev: {
            gtk3 = prev.gtk3.overrideAttrs (old: {
              src = prev.fetchgit {
                url = "https://gitlab.gnome.org/GNOME/gtk";
                # owner = "GNOME";
                # repo = "gtk";
                rev = "refs/heads/gtk-3-24";
                sha256 = "sha256-D3sr2iMneF3iyQ5RwLvfhGOQEhe+q9bQ4i48EJCnmWk=";
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
      overlays.default = _final: prev: {
        flutter-background-bar = prev.callPackage ./nix/package.nix {};
      };
    };
}
