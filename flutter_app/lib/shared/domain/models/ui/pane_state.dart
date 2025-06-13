class PaneState {
  PaneState({
    required this.width,
    required this.maxWidth,
    required this.minWidth,
    required this.enabled,
  });

  final double width;
  final double maxWidth;
  final double minWidth;
  final bool enabled;

  PaneState copyWith({
    double? width,
    double? maxWidth,
    double? minWidth,
    bool? enabled,
  }) {
    return PaneState(
      width: width ?? this.width,
      maxWidth: maxWidth ?? this.maxWidth,
      minWidth: minWidth ?? this.minWidth,
      enabled: enabled ?? this.enabled,
    );
  }
}
