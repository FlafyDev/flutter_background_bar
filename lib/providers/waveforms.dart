import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:file/memory.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';

final waveformsProvider = StreamProvider.family<List<double>, int>(
  (ref, bars) async* {
    if (kDebugMode) {
      yield List.generate(bars, (index) => Random().nextDouble());
    } else {
      final config = '''
[general]
bars = $bars
autosens = 1
[output]
method = raw
raw_target = /dev/stdout
bit_format = 16bit
''';
      final tempDir = await Directory.systemTemp.createTemp();

      final cavaConfigFile = File('${tempDir.path}/cava.conf');
      await cavaConfigFile.writeAsString(config);

      const bytesize = 2;
      const bytenorm = 65535;

      final chunkSize = bytesize * bars;

      final cavaProcess =
          await Process.start('cava', ['-p', cavaConfigFile.path]);

      await for (final dataChunk in cavaProcess.stdout) {
        if (dataChunk.length != chunkSize) continue;
        yield Uint8List.fromList(dataChunk)
            .buffer
            .asUint16List(0, bars)
            .map((e) => e / bytenorm)
            .toList();
      }

      throw 'Cava error: ${await cavaProcess.stderr.transform(utf8.decoder).join()}';
    }
  },
);
