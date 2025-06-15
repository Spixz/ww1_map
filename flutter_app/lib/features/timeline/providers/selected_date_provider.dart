import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/features/timeline/domain/models/date_interval.dart';

final selectedDateProvider = StateProvider<DateInterval>(
  (_) => DateInterval.todayUntil(endAt: DateTime(1914, 7, 28)),
);
