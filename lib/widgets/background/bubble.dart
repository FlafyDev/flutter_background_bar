import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Bubble extends HookConsumerWidget {
  const Bubble({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hoverAC = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    return Center(
      child: MouseRegion(
        onEnter: (_) => hoverAC.forward(),
        onExit: (_) => hoverAC.reverse(),
        child: AnimatedBuilder(
          animation: hoverAC,
          builder: (context, child) {
            return Transform.scale(
              scale: Curves.easeInOutCirc.transform(hoverAC.value) * 0.2 + 1,
              child: child,
            );
          },
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
    );
  }
}
