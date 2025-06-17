import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/core/constants.dart';
import 'package:ww1_map/features/timeline/domain/models/date_interval.dart';

// TODO : replace by a notifier
final selectedDateProvider = StateProvider<DateInterval>(
  (_) => DateInterval.today(day: startOfTheWar),
);
