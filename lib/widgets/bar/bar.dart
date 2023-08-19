import 'dart:io';
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
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.all(4).copyWith(top: 8),
      child: Row(
        children: [
          BarContainer(
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                  // child: Icon(Icons.window_rounded, color: Colors.white),
                  child: Image(
                width: 16,
                filterQuality: FilterQuality.medium,
                image: FileImage(
                  File(Platform.environment['FB_OS_LOGO']!),
                ),
                color: Colors.white,
              )),
            ),
          ),
          SizedBox(width: 4),
          WorkspacesIndicator(),
          Spacer(),
          Music(),
          // SizedBox(width: 4),
          // Sound(),
          SizedBox(width: 4),
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
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: child,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                // border: Border.fromBorderSide(
                //   BorderSide(
                //     color: Color(0x77777777),
                //   ),
                // ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black87,
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
