import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/features/right_pane/view/widgets/events_listview/events_listview.dart';
import 'package:ww1_map/features/right_pane/view/widgets/regiment_pane/regiment_description_tab.dart';

class RegimentTabs extends ConsumerWidget {
  const RegimentTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 7, 21, 29),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.brown.shade400,
              indicatorWeight: 3,
              tabs: [
                Tab(text: context.tr("Events")),
                Tab(text: context.tr("Description")),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [EventsListView(), RegimentDescription()],
            ),
          ),
        ],
      ),
    );
  }
}
