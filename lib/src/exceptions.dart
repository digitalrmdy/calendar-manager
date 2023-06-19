class CalendarManagerException implements Exception {
  final CalendarManagerErrorCode code;
  final String? message;
  final dynamic details;

  const CalendarManagerException({required this.code, this.message, this.details});

  @override
  String toString() {
    return '$CalendarManagerException{code: $code, message: $message, details: $details}';
  }
}

enum CalendarManagerErrorCode {
  PERMISSIONS_NOT_GRANTED,
  CALENDAR_READ_ONLY,
  CALENDAR_NOT_FOUND,
  UNKNOWN,
}

extension Name on CalendarManagerErrorCode {
  String get name => this.toString().split(".").last;
}
