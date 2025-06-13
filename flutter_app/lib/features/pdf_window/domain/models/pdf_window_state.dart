class PdfWindowState {
  const PdfWindowState({
    required this.title,
    required this.fileUrl,
    required this.display,
  });

  final String title;
  final String fileUrl;
  final bool display;

  PdfWindowState copyWith({String? title, String? fileUrl, bool? display}) {
    return PdfWindowState(
      title: title ?? this.title,
      fileUrl: fileUrl ?? this.fileUrl,
      display: display ?? this.display,
    );
  }
}

class EmptyPdfWindowState extends PdfWindowState {
  const EmptyPdfWindowState() : super(title: "", fileUrl: "", display: false);

  @override
  PdfWindowState copyWith({String? title, String? fileUrl, bool? display}) {
    return this;
  }
}
