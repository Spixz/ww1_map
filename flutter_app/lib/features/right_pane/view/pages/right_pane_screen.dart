import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/features/right_pane/providers/right_pane_notifier.dart';
import 'package:ww1_map/features/right_pane/view/widgets/content_tab.dart';
import 'package:ww1_map/features/right_pane/view/widgets/dragabble_bar.dart';
import 'package:ww1_map/features/right_pane/view/widgets/regiment_infos_header.dart';
import 'package:ww1_map/utils/extensions/extensions.dart';

class RightPaneScreen extends ConsumerStatefulWidget {
  const RightPaneScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UnitsPageState();
}

class _UnitsPageState extends ConsumerState<RightPaneScreen> {
  @override
  Widget build(BuildContext context) {
    final rightPane = ref.watch(rightPaneNotifierProvider);

    return SizedBox(
      child: Row(
        children: [
          DragabbleBar(),
          Container(
            width: rightPane.width,
            height: context.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(blurRadius: 20, offset: Offset.fromDirection(5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                RegimentInfosHeader(),
                Expanded(child: RightPaneContentTab()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
