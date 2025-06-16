import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/features/right_pane/view/widgets/events_listview.dart';

class AllEventsPane extends ConsumerWidget {
  const AllEventsPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EventsListView();
  }
}
