{
  lib,
  gtk-layer-shell,
  flutter,
}:
flutter.buildFlutterApplication {
  pname = "flutter-background-bar";
  version = "0.1.0";

  src = ../.;
  vendorHash = "";

  buildInputs = [
    gtk-layer-shell
  ];

  meta = with lib; {
    description = "flutter background + bar";
    homepage = "https://github.com/FlafyDev/flutter_background_bar";
    maintainers = [];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
