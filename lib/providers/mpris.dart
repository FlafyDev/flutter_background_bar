import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mpris/mpris.dart';
import 'package:collection/collection.dart';

@immutable
class Mpris {
  const Mpris({
    required this.playing,
    required this.cover,
    required this.length,
    required this.position,
    required this.title,
    required this.author,
  });

  factory Mpris.empty() => const Mpris(
        playing: false,
        cover: null,
        author: null,
        length: null,
        position: null,
        title: null,
      );

  final bool playing;
  final ImageProvider? cover;
  final Duration? length;
  final Duration? position;
  final String? title;
  final String? author;

  Mpris copyWith({
    bool? playing,
    ImageProvider? cover,
    Duration? length,
    Duration? position,
    String? title,
    String? author,
  }) {
    return Mpris(
      playing: playing ?? this.playing,
      cover: cover ?? this.cover,
      length: length ?? this.length,
      position: position ?? this.position,
      title: title ?? this.title,
      author: author ?? this.author,
    );
  }
}

// class MyMPRISService extends MPRISService {
//   MyMPRISService()
//       : super(
//           "identifier_string",
//           identity: "Application Name",
//           emitSeekedSignal: true,
//           canPlay: true,
//           canPause: true,
//           canGoPrevious: true,
//           canGoNext: true,
//           canSeek: true,
//           supportLoopStatus: false,
//           supportShuffle: false,
//         );
//
//   final toggleStream = StreamController<bool>.broadcast();
//   final titleStream = StreamController<String>.broadcast();
//   final positionStream = StreamController<Duration>.broadcast();
//   final lengthStream = StreamController<Duration>.broadcast();
//
//   @override
//   Future<void> onPlayPause() async {
//     toggleStream.add(playbackStatus == PlaybackStatus.playing);
//     print("onPlayPause");
//   }
//
//   @override
//   Future<void> onPlay() async {
//     print("onPlay");
//     // await player.play();
//   }
//
//   @override
//   Future<void> onPause() async {
//     print("onPause");
//   }
//
//   @override
//   Future<void> onPrevious() async {
//     print("onPrevious");
//   }
//
//   @override
//   Future<void> onNext() async {
//     print("onNext");
//   }
//
//   @override
//   Future<void> onSeek(int offset) async {
//     positionStream.add(Duration(seconds: offset));
//     print("onSeek");
//   }
//
//   @override
//   Future<void> onSetPosition(String trackId, int position) async {
//     print("onSetPosition");
//   }
//
//   @override
//   Future<void> onLoopStatus(LoopStatus loopStatus) async {
//     print("onLoopStatus");
//     this.loopStatus = loopStatus;
//   }
//
//   @override
//   Future<void> onShuffle(bool shuffle) async {
//     print("onShuffle");
//     this.shuffle = shuffle;
//   }
// }

class MprisNotifier extends StateNotifier<Mpris> {
  MprisNotifier() : super(Mpris.empty()) {
    MPRISPlayer? player;
    _loopStream =
        Stream<void>.periodic(const Duration(seconds: 1)).listen((_) async {
      try {
        await player?.getIdentity();
      } catch (e) {
        return;
      }
      final newPlayer = await _getFirstPlayingPlayer();
      if (newPlayer != null) player = newPlayer;
      if (player == null) return;
      final metadata = await player!.getMetadata();

      Duration? position;

      try {
        position = await player!.getPosition();
      } catch (e) {}

      state = Mpris(
        playing: await player!.getPlaybackStatus() == PlaybackStatus.playing,
        cover: metadata.trackArtUrl != null
            ? FileImage(
                File(
                  metadata.trackArtUrl!.replaceFirst(
                    'file://',
                    '',
                  ),
                ),
              )
            : null,
        length: metadata.trackLength,
        author: metadata.trackArtists?.join(', ') ?? '',
        position: position,
        title: metadata.trackTitle,
      );
    });
  }

  late StreamSubscription<void> _loopStream;
  final _mpris = MPRIS();
  // MPRISPlayer? player;

  Future<MPRISPlayer?> _getFirstPlayingPlayer() async {
    final players = await _mpris.getPlayers();
    final status =
        await Future.wait(players.map((pl) => pl.getPlaybackStatus()));
    final playingPlayerIndex =
        status.indexWhere((s) => s == PlaybackStatus.playing);
    return playingPlayerIndex == -1 ? null : players[playingPlayerIndex];
  }

  @override
  Future<void> dispose() async {
    await _mpris.close();
    await _loopStream.cancel();
    super.dispose();
  }

  // Future<void> toggle() {
  //   return service.();
  // }
  //
  // Future<void> next() {}
  //
  // Future<void> previous() {}
}

final mprisProvider = StateNotifierProvider<MprisNotifier, Mpris>((ref) {
  return MprisNotifier();
});
