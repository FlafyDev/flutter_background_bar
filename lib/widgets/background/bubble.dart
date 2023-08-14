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

class Bubbles extends HookConsumerWidget {
  const Bubbles({
    super.key,
    this.horizontalDistance = 0,
  });

  final double horizontalDistance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bubbleAC = useAnimationController(
      duration: const Duration(seconds: 20),
    );

    useEffect(
      () {
        bubbleAC
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              bubbleAC.repeat();
            }
          });

        return;
      },
      [],
    );

    return Stack(
      children: List.generate(5, (i) {
            const progresses = [0, 0.5, 0.1, 0.9, 0.2];
            const speed = [1.1, 1, 1, 1.2, 1];
            return AnimatedBuilder(
              animation: bubbleAC,
              builder: (context, child) {
                final radius = 500.0 + (i / 5 * 200);
                var progress = (bubbleAC.value * speed[i] + progresses[i]);
                while (progress > 1) progress -= 1;
                final angle = progress * pi / 2; // Convert the value to radians

                return Positioned(
                  top: radius * sin(angle) - 100 * 2,
                  left: radius * cos(angle) - 100 * 2 - horizontalDistance,
                  width: 100,
                  height: 100,
                  child: Transform.rotate(
                    angle: -progress * pi * 0.2,
                    child: child,
                  ),
                );
              },
              child: const Bubble(),
            );
          }) +
          List.generate(5, (i) {
            const progresses = [0, 0.5, 0.1, 0.4, 0.2];
            const speed = [1.1, 1, 1, 1, 1];
            return AnimatedBuilder(
              animation: bubbleAC,
              builder: (context, child) {
                final radius = 500.0 + (i / 5 * 200);
                var progress = (bubbleAC.value * speed[i] + progresses[i]);
                while (progress > 1) progress -= 1;
                final angle = progress * pi / 2; // Convert the value to radians

                return Positioned(
                  top: radius * sin(angle) - 100 * 2,
                  right: radius * cos(angle) - 100 * 2 - horizontalDistance,
                  width: 100,
                  height: 100,
                  child: Transform.rotate(
                    angle: -progress * pi * 0.2,
                    child: child,
                  ),
                );
              },
              child: const Bubble(),
            );
          }),
    );
  }
}
