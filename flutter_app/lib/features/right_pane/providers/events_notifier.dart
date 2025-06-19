import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:ww1_map/features/map/providers/map_informations_notifier.dart';
import 'package:ww1_map/features/right_pane/providers/selected_regiment_id_notifier.dart';
import 'package:ww1_map/features/timeline/providers/selected_date_provider.dart';
import 'package:ww1_map/shared/data/providers/events_repository_impl_provider.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';

enum EventsListMode { free, regiment }

final eventsListModeProvider = Provider((ref) {
  final selectedRegimentId = ref.watch(selectedRegimentIdProvider);

  return (selectedRegimentId == null)
      ? EventsListMode.free
      : EventsListMode.regiment;
});

final eventsProvider = AsyncNotifierProvider(EventsNotifier.new);

class EventsNotifier extends AsyncNotifier<List<WarEvent>> {
  double startAt = 0;
  int scrollPosition = 0;
  int lastFetchDoneForScrollPosition = 0;

  List<WarEvent> get events => state.value ?? [];

  @override
  Future<List<WarEvent>> build() async {
    final eventsRepository = ref.read(eventsRepositoryImplProvider);
    final eventsListMode = ref.watch(eventsListModeProvider);
    final selectedRegimentId = ref.watch(selectedRegimentIdProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    List<WarEvent> result = [];

    if (eventsListMode == EventsListMode.free) {
      final mapInformations = ref.watch(mapInformationsProvider);

      result = await eventsRepository.getEvents(
        after: selectedDate.start,
        before: selectedDate.date.add(Duration(days: 100)),
        bounds: mapInformations.bounds,
        offset: scrollPosition,
        limit: 15,
      );
    } else {
      result = await eventsRepository.getEvents(
        after: selectedDate.start,
        regimentId: selectedRegimentId,
        offset: scrollPosition,
        limit: 15,
      );
    }
    lastFetchDoneForScrollPosition = 0;

    return result;
  }

  Future loadMore() async {
    final eventsRepository = ref.read(eventsRepositoryImplProvider);
    final eventsListMode = ref.read(eventsListModeProvider);
    final selectedRegimentId = ref.read(selectedRegimentIdProvider);
    final mapInformations = ref.read(mapInformationsProvider);
    final selectedDate = ref.read(selectedDateProvider);

    if (state.isLoading) return;

    AsyncValue.guard(() async {
      List<WarEvent> result;

      if (eventsListMode == EventsListMode.free) {
        result = await eventsRepository.getEvents(
          bounds: mapInformations.bounds,
          after: selectedDate.start,
          before: selectedDate.date.add(Duration(days: 100)),
          offset: scrollPosition,
          limit: 15,
        );
      } else {
        result = await eventsRepository.getEvents(
          regimentId: selectedRegimentId,
          after: selectedDate.start,
          offset: scrollPosition,
          limit: 15,
        );
      }
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

  int? getEventPositionInList({required ObjectId id}) {
    final index = state.value?.indexWhere((event) => event.id == id);
    return (index != null && index != -1) ? index : null;
  }
}
