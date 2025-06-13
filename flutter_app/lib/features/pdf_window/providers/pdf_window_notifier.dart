// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/features/pdf_window/domain/models/pdf_window_state.dart';

final pdfWindowNotifierProvider = NotifierProvider(PdfWindowNotifier.new);

class PdfWindowNotifier extends Notifier<PdfWindowState> {
  @override
  PdfWindowState build() => EmptyPdfWindowState();

  void show() {
    if (this is EmptyPdfWindowState) return;
    state = state.copyWith(display: true);
  }

  void close() {
    if (this is EmptyPdfWindowState) return;
    state = state.copyWith(display: false);
  }

  void openDocument({required String title, required String url}) {
    if (this is EmptyPdfWindowState) return;
    state = PdfWindowState(title: title, fileUrl: url, display: true);
  }
}
