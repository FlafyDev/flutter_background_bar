import 'package:hooks_riverpod/hooks_riverpod.dart';

final timeProvider = StreamProvider((ref) async* {
  yield DateTime.now();
  await for (final _ in Stream.periodic(const Duration(seconds: 1), (i) => i)) {
    yield DateTime.now();
  }
});
