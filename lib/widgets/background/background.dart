// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_bar/providers/hyprland.dart';
import 'package:flutter_background_bar/providers/time.dart';
import 'package:flutter_background_bar/providers/waveforms.dart';
import 'package:flutter_background_bar/utils/bouncher.dart';
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
      duration: const Duration(milliseconds: 200),
    );

    useEffect(
      () {
        var activeWorkspace = '';
        var workspaces = <String, int>{};
        Future<void> checkWorkspaces(Event? event) async {
          if (event is CloseWindowEvent ||
              event is OpenWindowEvent ||
              event is WorkspaceEvent ||
              true) {
            workspaces = {};
            for (final client in await hyprland.value!.getClients()) {
              workspaces[client.workspaceName] =
                  (workspaces[client.workspaceName] ?? 0) +
                      (client.floating ? 0 : 1);
            }
            if (event is WorkspaceEvent) {
              activeWorkspace = event.workspaceName;
              workspaceNumber.value = int.parse(event.workspaceName);
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
          Image(
            image: FileImage(
              File(Platform.environment['FB_DESKTOP_BACKGROUND']!),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 400),
          //   curve: Curves.easeOut,
          //   // left: -5.0 * (5 - workspaceNumber.value) - 2.5,
          //   child: Image(
          //     image: AssetImage(
          //       '/nix/store/spna4cfdd6r3g2pbdwldz3k55fq9nvm3-windows11-flower.jpg',
          //     ),
          //     width: MediaQuery.of(context).size.width,
          //     height: MediaQuery.of(context).size.height,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: shownAC,
              builder: (context, child) {
                return Visibility(
                  visible: shownAC.value > 0,
                  child: Align(
                    alignment: Alignment(
                      0,
                      1.4 - (0.4 * Curves.easeOutExpo.transform(shownAC.value)),
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
                height: 200,
                child: _BackgroundWaveforms(),
              ),
            ),
          ),
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 400),
          //   curve: Curves.easeOut,
          //   left: -5.0 * (5 - workspaceNumber.value) - 2.5,
          //   child: Transform.scale(
          //     scale: 1.02,
          //     child: Image(
          //       image: AssetImage(
          //         '/home/flafy/Pictures/flower-front.png',
          //       ),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // Visibility(
          //   visible: !kDebugMode,
          //   child: AnimatedBuilder(
          //     animation: shownAC,
          //     builder: (context, child) {
          //       return Visibility(
          //         visible: shownAC.value > 0,
          //         child: Opacity(
          //           opacity: shownAC.value,
          //           child: Bubbles(
          //             horizontalDistance: 200 *
          //                 (1 - Curves.easeInOutExpo.transform(shownAC.value)),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          // Positioned.fill(
          //   child: AnimatedBuilder(
          //     animation: shownAC,
          //     builder: (context, child) {
          //       return Align(
          //         alignment: Alignment(
          //           0,
          //           (0.1 * Curves.easeOutExpo.transform(shownAC.value)) - 1,
          //         ),
          //         child: Visibility(
          //           visible: shownAC.value > 0,
          //           child: Opacity(
          //             opacity: shownAC.value,
          //             child: child,
          //           ),
          //         ),
          //       );
          //     },
          //     child: Consumer(
          //       builder: (context, ref, child) {
          //         final time = ref.watch(timeProvider);
          //         return time
          //                 .whenData(
          //                   (time) => Text(
          //                     DateFormat('HH:mm').format(time),
          //                     style: TextStyle(
          //                       fontSize: 100,
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.white,
          //                       decoration: TextDecoration.none,
          //                       shadows: <Shadow>[
          //                         Shadow(
          //                           offset: Offset(5.0, 5.0),
          //                           blurRadius: 10.0,
          //                           color: Color.fromARGB(255, 0, 0, 0),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 )
          //                 .value ??
          //             const SizedBox();
          //       },
          //     ),
          //   ),
          // ),

          Positioned(
            top: 432,
            left: 1370,
            child: Consumer(
              builder: (context, ref, child) {
                final time = ref.watch(timeProvider);
                return time
                        .whenData(
                          (time) => Text(
                            DateFormat('HH:mm').format(time),
                            style: TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 10.0,
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
          if (Platform.environment['FB_DESKTOP_BACKGROUND_TOP'] != null)
            Image(
              image: FileImage(
                File(Platform.environment['FB_DESKTOP_BACKGROUND_TOP']!),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
        ],
      ),
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
