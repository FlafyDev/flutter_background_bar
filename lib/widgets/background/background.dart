// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_bar/providers/hyprland.dart';
import 'package:flutter_background_bar/providers/time.dart';
import 'package:flutter_background_bar/providers/waveforms.dart';
import 'package:flutter_background_bar/utils/bouncher.dart';
import 'package:flutter_background_bar/widgets/background/bubble.dart';
import 'package:flutter_background_bar/widgets/bar/parts/music.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hyprland_ipc/hyprland_ipc.dart';
import 'package:intl/intl.dart';

class Background extends HookConsumerWidget {
  const Background({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hyprland = ref.watch(hyprlandProvider);
    final workspaceNumber = useState(0);
    final shownAC = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    useEffect(
      () {
        var activeWorkspace = '';
        var workspaces = <String, int>{};
        Future<void> checkWorkspaces(Event? event) async {
          if (event is CloseWindowEvent ||
              event is OpenWindowEvent ||
              event is WorkspaceEvent) {
            workspaces = {};
            for (final workspace in await hyprland.value!.getWorkspaces()) {
              workspaces[workspace.name] = workspace.windowsCount;
            }
            if (event is WorkspaceEvent) {
              activeWorkspace = event.workspaceName;
              workspaceNumber.value = int.parse(event.workspaceName);
              print(workspaceNumber.value);
            }
          }
          // print(workspaces);
          // print(activeWorkspace);
          if ((workspaces[activeWorkspace] ?? 0) < 1) {
            if (shownAC.status != AnimationStatus.forward) {
              unawaited(shownAC.forward());
            }
          } else {
            if (shownAC.status != AnimationStatus.reverse) {
              unawaited(shownAC.reverse());
            }
          }
          // emptyWorkspace.value = (workspaces[activeWorkspace] ?? 0) < 1;
        }

        final subscription =
            hyprland.value?.eventsStream.listen(checkWorkspaces);
        return () => subscription?.cancel();
      },
      [hyprland],
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            left: -5.0 * (5 - workspaceNumber.value) - 2.5,
            child: Transform.scale(
              scale: 1.02,
              child: Image(
                image: AssetImage(
                  '/home/flafydev/Pictures/greenery/green3.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: shownAC,
              builder: (context, child) {
                return Visibility(
                  visible: shownAC.value > 0,
                  child: Align(
                    alignment: Alignment(
                      0,
                      1 + (1 - Curves.easeInOutExpo.transform(shownAC.value)),
                    ),
                    child: Opacity(
                      opacity: shownAC.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: _BackgroundWaveforms(),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            left: -5.0 * (5 - workspaceNumber.value) - 2.5,
            child: Transform.scale(
              scale: 1.02,
              child: Image(
                image: AssetImage(
                  '/home/flafydev/Pictures/greenery/green3top.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Visibility(
            visible: !kDebugMode,
            child: AnimatedBuilder(
              animation: shownAC,
              builder: (context, child) {
                return Visibility(
                  visible: shownAC.value > 0,
                  child: Opacity(
                    opacity: shownAC.value,
                    child: Bubbles(
                      horizontalDistance: 200 *
                          (1 - Curves.easeInOutExpo.transform(shownAC.value)),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: shownAC,
              builder: (context, child) {
                return Align(
                  alignment: Alignment(
                    0,
                    -0.8 - (1 - Curves.easeInOutExpo.transform(shownAC.value)),
                  ),
                  child: Visibility(
                    visible: shownAC.value > 0,
                    child: Opacity(
                      opacity: shownAC.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: Consumer(
                builder: (context, ref, child) {
                  final time = ref.watch(timeProvider);
                  return time
                          .whenData(
                            (time) => Text(
                              DateFormat('HH:mm').format(time),
                              style: TextStyle(
                                fontSize: 200,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(20.0, 20.0),
                                    blurRadius: 20.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .value ??
                      const SizedBox();
                },
              ),
            ),
          ),
        ],
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

class _BackgroundWaveforms extends HookConsumerWidget {
  const _BackgroundWaveforms({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waveforms = ref.watch(waveformsProvider(50));
    return CustomPaint(
      painter: WaveformPainter(
        values: waveforms.valueOrNull ?? [],
        strokeWidth: 20,
        middle: false,
        round: false,
      ),
    );
  }
}
