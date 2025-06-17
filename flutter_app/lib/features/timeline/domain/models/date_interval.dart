class DateInterval {
  DateInterval({required this.start, required this.end}) {
    assert(!end.isBefore(start), 'end must be after start');
  }

  DateInterval.todayUntil({required DateTime endAt})
    : start = endAt.copyWith(hour: 0, minute: 0, second: 0),
      end = endAt;

  DateInterval.today({required DateTime day})
    : start = day.copyWith(hour: 0, minute: 0, second: 0),
      end = day.copyWith(hour: 23, minute: 59, second: 59);

  final DateTime start;
  final DateTime end;

  DateTime get date => end;
  DateTime get tommorow => end.copyWith(hour: 23, minute: 59, second: 59);

  @override
  String toString() => "start: $start / end: $end";
}
