import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';

final selectedEventProvider = NotifierProvider(SelectedEventNotifier.new);

class SelectedEventNotifier extends Notifier<WarEvent?> {
  @override
  WarEvent? build() => null;

  void set(WarEvent? event) => state = event;
}
