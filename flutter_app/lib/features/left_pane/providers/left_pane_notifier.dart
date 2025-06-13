import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/shared/domain/models/ui/pane_state.dart';

final leftPaneNotifierProvider = NotifierProvider(
  RegimentsPaneNotifier.new,
);

class RegimentsPaneNotifier extends Notifier<PaneState> {
  @override
  PaneState build() =>
      PaneState(width: 330, minWidth: 330, maxWidth: 700, enabled: true);

  void updateWidth(double width) {
    if (width <= state.maxWidth && width >= state.minWidth) {
      state = state.copyWith(width: width);
    }
  }

  void toogle() => state = state.copyWith(enabled: !state.enabled);
  void hide() => state = state.copyWith(enabled: false);
  void show() => state = state.copyWith(enabled: true);
}
