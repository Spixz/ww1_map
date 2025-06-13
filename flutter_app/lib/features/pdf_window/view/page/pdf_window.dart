import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:ww1_map/common_widgets/empty.dart';
import 'package:ww1_map/core/colors.dart';
import 'package:ww1_map/features/pdf_window/providers/pdf_window_notifier.dart';

class PdfWindowScreen extends ConsumerStatefulWidget {
  const PdfWindowScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PdfViewerScreenState();
}

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
        final container = Container(color: Colors.black);

        return Align(
          alignment: Alignment.bottomRight,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                width: 10,
                height: 27,
                child: container,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                width: 27,
                height: 10,
                child: container,
              ),
            ],
          ),
        );
        //return Icon(Icons.drag_indicator);

        // return DefaultCornerHandle(handle: handle);
      },
      contentBuilder:
          (context, rect, flip) => Transform.scale(
            scaleX: flip.isHorizontal ? -1 : 1,
            scaleY: flip.isVertical ? -1 : 1,
            child: Container(
              decoration: BoxDecoration(
                color: dragabbleWindowBarColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                ),
                boxShadow: [BoxShadow(offset: Offset(5, 5), blurRadius: 5)],
              ),
              child: Column(
                children: [WindowTopBar(), Expanded(child: PdfContent())],
              ),
            ),
          ),
    );
  }
}

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

class PdfContent extends ConsumerWidget {
  const PdfContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final windowState = ref.watch(pdfWindowNotifierProvider);

    return PdfViewer.uri(
      Uri.parse(windowState.fileUrl),
      params: PdfViewerParams(
        loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                context.tr("HeavyDocumentLoading"),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
