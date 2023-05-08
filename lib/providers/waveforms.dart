import 'package:hooks_riverpod/hooks_riverpod.dart';

final waveformsProvider = StreamProvider<List<int>>(
  (ref) async* {
    const bars = 10;
    const config = '''
[general]
bars = $bars
[output]
method = raw
raw_target = 16bit
bit_format = /dev/stdout
    ''';
  },
);
