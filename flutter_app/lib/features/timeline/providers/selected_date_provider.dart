import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/core/constants.dart';
import 'package:ww1_map/features/timeline/domain/models/date_interval.dart';

final selectedDateProvider = NotifierProvider(SelectedDateNotifier.new);

class SelectedDateNotifier extends Notifier<DateInterval> {
  @override
  DateInterval build() => DateInterval.today(day: startOfTheWar);

  void update(DateInterval interval) => state = interval;
}
