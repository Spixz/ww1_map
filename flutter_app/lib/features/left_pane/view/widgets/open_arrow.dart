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
        color: Colors.grey,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: InkWell(
        onTap: () => ref.read(leftPaneNotifierProvider.notifier).show(),
        child: Icon(Icons.arrow_forward_ios, color: Colors.white),
      ),
    );
  }
}