class JsonParseException implements Exception {
  final String message;
  final Object? originalException;
  final StackTrace? stacktrace;

  JsonParseException(this.message, {this.originalException, this.stacktrace});

  @override
  String toString() {
    return "JsonParseException: $message\nCause: $originalException\n$stacktrace";
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? endpoint;

  ApiException(this.message, {this.statusCode, this.endpoint});

  @override
  String toString() {
    return 'ApiException: $message'
        '${statusCode != null ? " (Code HTTP: $statusCode)" : ""}'
        '${endpoint != null ? " - Endpoint: $endpoint" : ""}';
  }
}

class DetailedException implements Exception {
  DetailedException({
    required this.cause,
    required this.detailedMessage,
    this.trace,
  });
  final String detailedMessage;
  final Object cause;
  final StackTrace? trace;

  @override
  String toString() {
    final buffer =
        StringBuffer()
          ..writeln('Detailed message: $detailedMessage')
          ..writeln('Original error: $cause');
    if (trace != null) {
      buffer.writeln('Stack trace:\n$trace');
    }
    return buffer.toString();
  }
}
