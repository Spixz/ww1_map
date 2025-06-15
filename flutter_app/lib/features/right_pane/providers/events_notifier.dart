
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/features/map/providers/map_informations_notifier.dart';
import 'package:ww1_map/features/right_pane/providers/selected_regiment_provider.dart';
import 'package:ww1_map/features/timeline/providers/selected_date_provider.dart';
import 'package:ww1_map/shared/data/providers/events_repository_impl_provider.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';
import 'package:ww1_map/shared/domain/repositories/war_events_repository.dart';

class EventsNotifier extends Notifier<AsyncValue<List<WarEvent>>>{
  @override
  AsyncValue<List<WarEvent>> build() {
    //call du refresh
    return AsyncLoading();
  }

  void loadEvents() async {
    final selectedRegimentId = ref.watch(selectedRegimentIdProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final mapInformations = ref.watch(mapInformationsProvider);

    state = AsyncLoading();
    final result =    ref.read(eventsRepositoryImplProvider);
  }
}