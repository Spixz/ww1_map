import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:ww1_map/common_widgets/centered_error.dart';
import 'package:ww1_map/common_widgets/common_widgets_export.dart';
import 'package:ww1_map/core/colors.dart';
import 'package:ww1_map/features/map/providers/selected_event_provider.dart';
import 'package:ww1_map/features/right_pane/providers/events_notifier.dart';
import 'package:ww1_map/features/right_pane/view/widgets/events_listview/event_infos.dart';
import 'package:ww1_map/utils/extensions/datetime_extension.dart';

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
      final lastItemDisplayed = itemPositionsListener.itemPositions.value.last;
      ref
          .read(eventsProvider.notifier)
          .updateScrollPosition(lastItemDisplayed.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsList = ref.watch(eventsProvider);

    ref.listen(selectedEventProvider, (_, selectedEvent) {
      if (selectedEvent == null) return;
      final selectedEventPosition = ref
          .read(eventsProvider.notifier)
          .getEventPositionInList(id: selectedEvent.id!);

      if (selectedEventPosition != null) {
        itemScrollController.scrollTo(
          index: selectedEventPosition,
          duration: Duration(milliseconds: 500),
        );
      }
    });

    return eventsList.when(
      data: (events) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: ScrollablePositionedList.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              if (index > 0) {
                final prevEvent = events[index - 1];

                if (event.startDate!.isSameDay(prevEvent.startDate!)) {
                  return EventInfos(event);
                }
              }

              return Column(
                spacing: 15,
                children: [_DateHeader(event.startDate!), EventInfos(event)],
              );
            },
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
          ),
        );
      },
      error: (_, __) => CenteredMessage(message: context.tr("Error")),
      loading: () => CircularLoading(),
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader(this.date);
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat("d MMMM y");

    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: rightPaneHeaderColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          formatter.format(date).toUpperCase(),
          style: TextStyle(fontSize: 23, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
