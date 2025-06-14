import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/left_pane/providers/left_pane_notifier.dart';

class CloseArrow extends ConsumerWidget {
  const CloseArrow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: Center(
        child: InkWell(
          onTap: () => ref.read(leftPaneNotifierProvider.notifier).hide(),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              boxShadow: [
                // BoxShadow(blurRadius: 20, offset: Offset(5, 5)),
              ],
            ),
            child: Icon(Icons.arrow_back_ios, size: 24,),
          ),
        ),
      ),
    );
  }
}
