import 'package:flutter/material.dart';

import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/common_widgets/empty.dart';
import 'package:ww1_map/core/colors.dart';
import 'package:ww1_map/features/pdf_window/providers/pdf_window_notifier.dart';
import 'package:ww1_map/features/pdf_window/view/widgets/drag_coner.dart';
import 'package:ww1_map/features/pdf_window/view/widgets/pdf_content.dart';
import 'package:ww1_map/features/pdf_window/view/widgets/top_bar.dart';

class PdfWindowScreen extends ConsumerStatefulWidget {
  const PdfWindowScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PdfViewerScreenState();
}

// TODO : use a controller not the state
class _PdfViewerScreenState extends ConsumerState<PdfWindowScreen> {
  Rect rect = Rect.fromPoints(Offset(0, 0), Offset(700, 800));
  Flip flip = Flip.none;

  @override
  Widget build(BuildContext context) {
    final windowState = ref.watch(pdfWindowNotifierProvider);

    if (!windowState.display) return Empty();

    return TransformableBox(
      rect: rect,
      flip: flip,
      constraints: BoxConstraints(minHeight: 300, minWidth: 300),
      onChanged: (transformResult, dragDetails) {
        setState(() {
          rect = transformResult.rect;
          flip = transformResult.flip;
        });
      },
      sideHandleBuilder: (context, handle) => Empty(),
      cornerHandleBuilder: (context, handle) {
        if (handle != HandlePosition.bottomRight) return Empty();
        return DragCorner();
      },
      contentBuilder:
          (context, rect, flip) => Transform.scale(
            scaleX: flip.isHorizontal ? -1 : 1,
            scaleY: flip.isVertical ? -1 : 1,
            child: Container(
              decoration: BoxDecoration(
                color: dragabbleWindowBarColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                  bottom: Radius.circular(9),
                ),
                boxShadow: [BoxShadow(offset: Offset(5, 5), blurRadius: 5)],
              ),
              child: const Column(
                children: [WindowTopBar(), Expanded(child: PdfContent())],
              ),
            ),
          ),
    );
  }
}
