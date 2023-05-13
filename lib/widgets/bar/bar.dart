import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_bar/widgets/bar/parts/time.dart';
import 'package:flutter_background_bar/widgets/bar/parts/music.dart';
import 'package:flutter_background_bar/widgets/bar/parts/sound.dart';
import 'package:flutter_background_bar/widgets/bar/parts/workspaces/workspaces.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Bar extends HookConsumerWidget {
  const Bar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 70,
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      child: Row(
        children: const [
          BarContainer(
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                // child: Icon(Icons.window_rounded, color: Colors.white),
                child: Image(
                  width: 20,
                  filterQuality: FilterQuality.medium,
                  image: AssetImage('/home/flafydev/Pictures/hyprland.png'),
                  color: Colors.white,
                )
              ),
            ),
          ),
          SizedBox(width: 8),
          WorkspacesIndicator(),
          Spacer(),
          Music(),
          SizedBox(width: 8),
          Sound(),
          SizedBox(width: 8),
          Time(),
        ],
      ),
    );
  }
}

class BarContainer extends HookConsumerWidget {
  const BarContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: child,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.fromBorderSide(
                  BorderSide(
                    color: Color(0xff777777),
                    width: 0.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
