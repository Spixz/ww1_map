import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/right_pane/view/widgets/regiment_pane/regiment_tabs.dart';
import 'package:ww1_map/features/right_pane/view/widgets/regiment_pane/regiment_infos_header.dart';

class RegimentPane extends ConsumerWidget {
  const RegimentPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        RegimentInfosHeader(),
        Expanded(child: RegimentTabs()),
      ],
    );
  }
}
