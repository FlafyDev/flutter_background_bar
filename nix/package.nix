{
  lib,
  gtk-layer-shell,
  flutter,
  cava,
  cacert,
  pkg-config,
}:
flutter.buildFlutterApplication {
  pname = "flutter-background-bar";
  version = "0.1.0";

  src = ../.;
  depsListFile = ./deps.json;
  vendorHash = "sha256-XKxPPa/NW5EuwInO2u6vYjAt8cO7Q/+gAMuTHv15qRE=";
  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk-layer-shell
  ];

  pubGetScript = "dart --root-certs-file=${cacert}/etc/ssl/certs/ca-bundle.crt pub get";

  postFixup = ''
    wrapProgram $out/bin/flutter_background_bar --suffix PATH : ${lib.makeBinPath [cava]}
  '';

  meta = with lib; {
    description = "flutter background + bar";
    homepage = "https://github.com/FlafyDev/flutter_background_bar";
    maintainers = [];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
