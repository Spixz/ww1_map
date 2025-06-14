import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/features/pdf_window/providers/pdf_window_notifier.dart';

class WindowTopBar extends ConsumerWidget {
  const WindowTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final windowState = ref.watch(pdfWindowNotifierProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => ref.read(pdfWindowNotifierProvider.notifier).close(),
          icon: Icon(Icons.close, size: 18, color: Colors.black),
        ),
        Text(windowState.title),
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.close, size: 18),
          ),
        ),
      ],
    );
  }
}
