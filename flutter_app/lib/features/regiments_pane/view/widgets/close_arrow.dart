import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/regiments_pane/providers/regiments_pane_notifier.dart';

class CloseArrow extends ConsumerWidget {
  const CloseArrow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => ref.read(regimentPaneNotifierProvider.notifier).hide(),
      child: Icon(Icons.arrow_back_ios, size: 30),
    );
  }
}
