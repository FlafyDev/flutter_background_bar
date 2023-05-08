// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_background_bar/providers/mpris.dart';
import 'package:flutter_background_bar/widgets/bar/bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Music extends HookConsumerWidget {
  const Music({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BarContainer(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Consumer(
          builder: (context, ref, child) {
            final playing =
                ref.watch(mprisProvider.select((value) => value.playing));
            final cover =
                ref.watch(mprisProvider.select((value) => value.cover));

            return Stack(
              children: [
                Opacity(
                  opacity: 0.2,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image(
                      fit: BoxFit.cover,
                      image: cover!,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                ),
              ],
            );

            return Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      return cover == null
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white.withOpacity(0.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    foregroundDecoration: BoxDecoration(
                                      color: playing
                                          ? Colors.transparent
                                          : Colors.grey, // On pause
                                      backgroundBlendMode: BlendMode.saturation,
                                    ),
                                    child: Image(
                                      fit: BoxFit.cover,
                                      image: cover,
                                      filterQuality: FilterQuality.medium,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                  _MusicInfoControls(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MusicInfoControls extends StatelessWidget {
  const _MusicInfoControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Consumer(
                  builder: (context, ref, child) {
                    final title = ref.watch(
                          mprisProvider.select(
                            (value) => value.title,
                          ),
                        ) ??
                        'none';
                    return Text(
                      title,
                      maxLines: 1,
                      // overflow: TextOverflow.clip,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  },
                ),
                // Expanded(
                //   child: Marquee(
                //     text:
                //         '"Revenge" - A Minecraft Parody of Usher\'s DJ Got Us Fallin\' In Love (Music Video)',
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //     startAfter: Duration(seconds: 4),
                //     fadingEdgeEndFraction: 0.1,
                //     showFadingOnlyWhenScrolling: false,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     blankSpace: 40,
                //     velocity: 40,
                //     pauseAfterRound: Duration(seconds: 4),
                //     accelerationDuration: Duration(seconds: 1),
                //     accelerationCurve: Curves.linear,
                //     decelerationDuration: Duration(milliseconds: 500),
                //     decelerationCurve: Curves.easeOut,
                //   ),
                // ),
                const SizedBox(height: 1),
                Consumer(
                  builder: (context, ref, child) {
                    final author = ref.watch(
                          mprisProvider.select(
                            (value) => value.author,
                          ),
                        ) ??
                        '';
                    return Text(
                      author,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 12),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment(0, 1.2),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Consumer(
                        builder: (context, ref, child) {
                          final position = ref.watch(
                            mprisProvider.select(
                              (value) => value.position,
                            ),
                          );
                          final length = ref.watch(
                            mprisProvider.select(
                              (value) => value.length,
                            ),
                          );
                          if (length == null || position == null) {
                            return const SizedBox();
                          }
                          return LinearProgressIndicator(
                            value: position.inSeconds / length.inSeconds,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 20,
                  ),
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                  Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
