# Flutter background bar
###### Very W.I.P. Temporary name.
The code is a mess, needs to be heavily refactored.

---

Flutter app for desktop UI.  
A Layer Shell that sits in the background(behind the windows).  
The point is to have an interactive background and a bar with blur.

Bar code is at `lib/widgets/bar`

## More performance 

While you can just use `flutter build linux --release` to build this, it will use the official embedder for Linux that flutter provides, and that might be too slow.  
For a better embedder(yet still WIP), you can use [flutter-elinux](https://github.com/sony/flutter-embedded-linux).  
flutter-elinux doesn't come with a layer shell backend, so i made my own [here]().  
just get regular flutter-elinux and compile the libflutter_elinux_wayland.so(from my fork) for x64 release yourself.  


