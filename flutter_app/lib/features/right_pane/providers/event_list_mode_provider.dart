import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/right_pane/providers/selected_regiment_id_notifier.dart';
import 'package:ww1_map/shared/domain/enums/events_list_mode.dart';

final eventsListModeProvider = Provider((ref) {
  final selectedRegimentId = ref.watch(selectedRegimentIdProvider);

  return (selectedRegimentId == null)
      ? EventsListMode.free
      : EventsListMode.regiment;
});