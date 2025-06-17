import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/map/providers/selected_event_provider.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';

class EventInfos extends ConsumerWidget {
  const EventInfos(this.event);
  final WarEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => ref.read(selectedEventProvider.notifier).set(event),
      child: Column(
        spacing: 10,
        children: [EventInfosBody(event), SizedBox(height: 10)],
      ),
    );
  }
}

class EventInfosBody extends ConsumerWidget {
  const EventInfosBody(this.event, {super.key});
  final WarEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        Text(event.description, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
