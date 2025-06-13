import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:ww1_map/core/colors.dart';

class RightPaneContentTab extends ConsumerWidget {
  const RightPaneContentTab({super.key});

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
              tabs: [
                Tab(text: context.tr("Events")),
                Tab(text: context.tr("Description")),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [

                Icon(Icons.directions_transit),
                Icon(Icons.directions_transit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
