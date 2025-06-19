import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/left_pane/providers/left_pane_notifier.dart';
import 'package:ww1_map/features/left_pane/view/widgets/close_arrow.dart';
import 'package:ww1_map/features/left_pane/view/widgets/list_regiments.dart';
import 'package:ww1_map/features/left_pane/view/widgets/open_arrow.dart';
import 'package:ww1_map/utils/extensions/extensions.dart';

class LeftPaneScreen extends ConsumerWidget {
  const LeftPaneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paneState = ref.watch(leftPaneNotifierProvider);

    if (!paneState.enabled) {
      return SizedBox(
        height: context.height,
        child: Center(child: OpenArrow()),
      );
    } else {
      return const Row(children: [ListRegiments(), CloseArrow()]);
    }
  }
}

