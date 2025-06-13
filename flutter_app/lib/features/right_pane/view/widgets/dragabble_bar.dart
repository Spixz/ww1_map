import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/right_pane/providers/right_pane_notifier.dart';
import 'package:ww1_map/utils/extensions/extensions.dart';

class DragabbleBar extends ConsumerWidget {
  const DragabbleBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          final actualWidth = ref.read(rightPaneNotifierProvider).width;
          ref
              .read(rightPaneNotifierProvider.notifier)
              .updateWidth(actualWidth - details.delta.dx);
        },
        child: Container(
          height: context.height,
          color: Colors.transparent,
          child: const _DragIndicator(),
        ),
      ),
    );
  }
}

class _DragIndicator extends StatelessWidget {
  const _DragIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60,
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
        child: Icon(Icons.drag_indicator),
      ),
    );
  }
}
