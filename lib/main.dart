import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_bar/widgets/background/background.dart';
import 'package:flutter_background_bar/widgets/bar/bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        // primaryColor: Colors.white,
        // primaryColorDark: Colors.white,
        primarySwatch: Colors.grey,
        sliderTheme: SliderThemeData(
          overlayShape: SliderComponentShape.noOverlay,
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.white.withOpacity(0.5),
          thumbColor: Colors.white,
          overlayColor: Colors.white.withOpacity(0.5),
          thumbShape: SliderComponentShape.noThumb,
          trackHeight: 2,
        ),
      ),
      home: Scaffold(
        body: Stack(
          children: [
            const Background(),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Bar(),
            ),
          ],
        ),
      ),
    );
  }
}
