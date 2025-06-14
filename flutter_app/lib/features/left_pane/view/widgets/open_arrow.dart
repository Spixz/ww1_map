import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/left_pane/providers/left_pane_notifier.dart';

class OpenArrow extends ConsumerWidget {
  const OpenArrow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [BoxShadow(blurRadius: 12, offset: Offset(1, 1))],
      ),
      child: InkWell(
        onTap: () => ref.read(leftPaneNotifierProvider.notifier).show(),
        child: Icon(Icons.arrow_forward_ios, color: Colors.black),
      ),
    );
  }
}
