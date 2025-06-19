import 'dart:async';

class Debouncer {
  Debouncer({required this.delay});

  final Duration delay;
  Timer? _timer;

  void call(void Function() fc) {
    _timer?.cancel();
    _timer = Timer(delay, fc);
  }
}
