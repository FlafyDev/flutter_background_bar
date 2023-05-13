import 'dart:async';

class Debouncer {
  Timer? _timer;

  Future<void> debounce(Duration duration, void Function() action) {
    final completer = Completer<void>();

    _timer?.cancel();

    _timer = Timer(duration, () {
      action();
      completer.complete();
    });

    return completer.future;
  }
}
