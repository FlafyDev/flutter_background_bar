import 'dart:ui';

import 'package:flutter/material.dart';
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
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('/home/flafydev/Pictures/greenery/green3.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: ClipRRect(
                    // TODO(flafydev): Figure out how to Clip as a circle
                    borderRadius: BorderRadius.circular(1000),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: const Image(
                        image: AssetImage('assets/bubble.png'),
                      ),
                    ),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Bar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
