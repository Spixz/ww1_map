import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import 'package:ww1_map/features/pdf_window/providers/pdf_window_notifier.dart';

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
