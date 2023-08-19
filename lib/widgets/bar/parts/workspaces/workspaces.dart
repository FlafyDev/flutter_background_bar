import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_bar/providers/hyprland.dart';
import 'package:flutter_background_bar/utils/bouncher.dart';
import 'package:flutter_background_bar/widgets/bar/bar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_animations/src/animation_configurator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hyprland_ipc/hyprland_ipc.dart';

class WorkspacesIndicatorWindow {
  const WorkspacesIndicatorWindow({
    required this.icon,
    required this.rect,
    required this.active,
    required this.floating,
    required this.fullscreen,
  });

  final IconData icon;
  final Rect rect;
  final bool active;
  final bool floating;
  final bool fullscreen;
}

class WorkspacesIndicator extends HookConsumerWidget {
  const WorkspacesIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hyprland = ref.watch(hyprlandProvider);
    final windows =
        useState(SplayTreeMap<int, List<WorkspacesIndicatorWindow>>());

    useEffect(
      () {
        final closedWindows = <int>[];
        Future<void> updateWindows(Event? event) async {
          // TODO(flafy): update it automatically
          const bottomReserved = 40.0;

          // TODO(flafy): update hyprland_ipc and change this
          Client? activeWindow;
          try {
            activeWindow = await hyprland.value!.getActiveWindow();
          } catch (e) {}

          final tempWindows =
              SplayTreeMap<int, List<WorkspacesIndicatorWindow>>();
          final hyprWindows = await hyprland.value!.getClients();

          for (final hyprWindow in hyprWindows) {
            if (closedWindows.contains(hyprWindow.address)) continue;

            if (tempWindows[hyprWindow.workspaceId] == null) {
              tempWindows[hyprWindow.workspaceId] = [];
            }

            IconData icon;
            switch (hyprWindow.className) {
              case 'firefox':
                icon = Icons.web;
                break;
              case 'mpv':
                icon = Icons.movie;
                break;
              case 'footclient':
              case 'foot':
                if (hyprWindow.title.contains(' - nvim')) {
                  icon = Icons.code;
                } else {
                  icon = Icons.terminal;
                }
                break;
              default:
                icon = Icons.window;
            }

            tempWindows[hyprWindow.workspaceId]!.add(
              WorkspacesIndicatorWindow(
                active: activeWindow?.address == hyprWindow.address,
                icon: icon,
                rect: Rect.fromLTRB(
                  (hyprWindow.rect.left.toDouble() / 1920.0).clamp(0, 1),
                  (hyprWindow.rect.top.toDouble() / (1080.0 - bottomReserved))
                      .clamp(0, 1),
                  (hyprWindow.rect.right.toDouble() / 1920.0).clamp(0, 1),
                  (hyprWindow.rect.bottom.toDouble() /
                          (1080.0 - bottomReserved))
                      .clamp(0, 1),
                ),
                floating: hyprWindow.floating,
                fullscreen: hyprWindow.fullscreen,
              ),
            );
            for (final key in tempWindows.keys) {
              tempWindows[key]!.sort((a, b) {
                if (a.fullscreen) {
                  return 2;
                } else if (a.floating) {
                  return 1;
                } else {
                  return 0;
                }
              });
            }
            windows.value = tempWindows;
          }
        }

        final debouncer = Debouncer();
        final subscription = hyprland.value?.eventsStream.listen((event) {
          if (event is CloseWindowEvent) {
            closedWindows.add(event.windowAddress);
          }
          if (event is OpenWindowEvent) {
            closedWindows.remove(event.windowAddress);
          }
          debouncer.debounce(const Duration(milliseconds: 50), () {
            updateWindows(event);
          });
        });
        if (hyprland.value != null) updateWindows(null);
        return () => subscription?.cancel();
      },
      [hyprland],
    );

    return BarContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 0,
        ),
        child: Row(
          children: AnimationConfiguration.toStaggeredList(
            delay: Duration.zero,
            duration: const Duration(milliseconds: 800),
            childAnimationBuilder: (widget) => ClipAnimation(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: SlideAnimation(
                curve: Curves.elasticOut,
                child: widget,
              ),
            ),
            children: List.generate(
                windows.value.keys.fold(0, (maximum, id) => max(maximum, id)),
                (id) {
              final wins = windows.value[id + 1] ?? [];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 4,
                ),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 100),
                  scale: 1,
                  // scale: wins.any((win) => win.active) ? 1.1 : 1,
                  curve: Curves.easeOut,
                  child: Container(
                    decoration: BoxDecoration(
                        // color: Colors.white.withOpacity(0.08),
                        ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    // padding: const EdgeInsets.all(3),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: LayoutBuilder(
                        builder: (context, contraints) {
                          return Stack(
                            children: wins.map((win) {
                              return Positioned.fromRect(
                                rect: Rect.fromLTRB(
                                  win.rect.left * contraints.maxWidth,
                                  win.rect.top * contraints.maxHeight,
                                  win.rect.right * contraints.maxWidth,
                                  win.rect.bottom * contraints.maxHeight,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // border: Border.fromBorderSide(
                                            //   BorderSide(
                                            //     color: Color(0x77777777),
                                            //   ),
                                            // ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black38,
                                                blurRadius: 5,
                                                blurStyle: BlurStyle.outer,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        // borderRadius: BorderRadius.circular(4),
                                        child: BackdropFilter(
                                          filter: win.floating || win.fullscreen
                                              ? ImageFilter.blur(
                                                  sigmaX: 2,
                                                  sigmaY: 2,
                                                )
                                              : ImageFilter.blur(),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              // border: Border.all(
                                              //   color: win.floating
                                              //       ? const Color(0x44aaaaaa)
                                              //       : Colors.transparent,
                                              // ),
                                              color: win.active
                                                  ? const Color(0x63dddddd)
                                                  : const Color(0x44666666),
                                              // borderRadius: BorderRadius.circular(4),
                                            ),
                                            padding: const EdgeInsets.all(2),
                                            child: Center(
                                              child: FittedBox(
                                                child: Icon(
                                                  size: 15,
                                                  win.icon,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class ClipAnimation extends StatelessWidget {
  const ClipAnimation({
    this.duration,
    this.delay,
    this.curve = Curves.ease,
    required this.child,
    super.key,
  }) : super();
  final Duration? duration;
  final Duration? delay;
  final Curve curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimationConfigurator(
      duration: duration,
      delay: delay,
      animatedChildBuilder: _clipAnimation,
    );
  }

  Widget _clipAnimation(Animation<double> animation) {
    final anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(0, 1, curve: curve),
      ),
    );

    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: anim.value,
        child: child,
      ),
    );
  }
}
