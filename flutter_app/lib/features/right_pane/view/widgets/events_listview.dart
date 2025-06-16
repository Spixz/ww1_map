import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:ww1_map/common_widgets/centered_error.dart';
import 'package:ww1_map/common_widgets/common_widgets_export.dart';
import 'package:ww1_map/features/right_pane/providers/events_notifier.dart';

class EventsListView extends ConsumerStatefulWidget {
  const EventsListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventListViewState();
}

class _EventListViewState extends ConsumerState<EventsListView> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(() {
      final lastItem = itemPositionsListener.itemPositions.value.last;
      ref
          .read(eventNotifierProvider.notifier)
          .updateScrollPosition(lastItem.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsProvider = ref.watch(eventNotifierProvider);

    return eventsProvider.when(
      data: (events) {
        return ScrollablePositionedList.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Text('$index ${event.title}', style: TextStyle(fontSize: 16));
          },
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
        );
      },
      error: (_, __) => CenteredError(),
      loading: () => CircularLoading(),
    );
  }
}
