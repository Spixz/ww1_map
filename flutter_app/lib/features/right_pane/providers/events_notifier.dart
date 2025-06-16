import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/map/providers/map_informations_notifier.dart';
import 'package:ww1_map/features/right_pane/providers/selected_regiment_id_notifier.dart';
import 'package:ww1_map/features/right_pane/providers/selected_regiment_provider.dart';
import 'package:ww1_map/features/timeline/providers/selected_date_provider.dart';
import 'package:ww1_map/shared/data/providers/events_repository_impl_provider.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';

final eventNotifierProvider = AsyncNotifierProvider(EventsNotifier.new);

class EventsNotifier extends AsyncNotifier<List<WarEvent>> {
  double startAt = 0;
  int scrollPosition = 0;
  int lastFetchDoneForScrollPosition = 0;

  List<WarEvent> get events => state.value ?? [];

  @override
  Future<List<WarEvent>> build() async {
    final eventsRepository = ref.watch(eventsRepositoryImplProvider);
    final selectedRegimentId = ref.watch(selectedRegimentIdProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final mapInformations = ref.watch(mapInformationsProvider);

    final result = await eventsRepository.getEvents(
      regimentId: selectedRegimentId,
      // interval: selectedDate,
      // bounds: mapInformations.bounds,
      startAt: scrollPosition,
      limit: 15,
    );
    lastFetchDoneForScrollPosition = 0;

    return result;
  }

  Future loadMore() async {
    final eventsRepository = ref.read(eventsRepositoryImplProvider);
    final selectedRegimentId = ref.read(selectedRegimentIdProvider);
    final selectedDate = ref.read(selectedDateProvider);
    final mapInformations = ref.read(mapInformationsProvider);

    if (state.isLoading) return;

    AsyncValue.guard(() async {
      final result = await eventsRepository.getEvents(
        regimentId: selectedRegimentId,
        // interval: selectedDate,
        // bounds: mapInformations.bounds,
        startAt: scrollPosition,
        limit: 15,
      );
      lastFetchDoneForScrollPosition = scrollPosition;
      state = AsyncData(events + result);
    });
  }

  void updateScrollPosition(int position) {
    scrollPosition = position;

    if (scrollPosition == events.length - 1 &&
        lastFetchDoneForScrollPosition != position) {
      lastFetchDoneForScrollPosition = position;
      loadMore();
    }
  }
}
