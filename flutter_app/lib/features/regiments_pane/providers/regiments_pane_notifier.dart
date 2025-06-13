import 'package:flutter_riverpod/flutter_riverpod.dart';

final regimentPaneNotifierProvider = NotifierProvider(
  RegimentsPaneNotifier.new,
);

class RegimentsPaneNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toogle() => state = !state;
  void hide() => state = false;
  void show() => state = true;
}
