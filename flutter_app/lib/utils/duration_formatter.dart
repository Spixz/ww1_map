import 'package:ww1_map/utils/tr_entry.dart';

class DurationFormatter {
  static TrEntry abreviate(Duration duration) {
    if (duration.inHours < 1) {
      return TrEntry(
        i18nIndex: "RatingBar.min",
        args: [duration.inMinutes.toString()],
      ); //< 1 min
    } else if (duration.inDays < 1) {
      return TrEntry(
        i18nIndex: "RatingBar.hour",
        args: [duration.inHours.toString()],
      ); //< 1 min
    } else {
      return TrEntry(
        i18nIndex: "RatingBar.day",
        args: [duration.inDays.toString()],
      ); //< 1 min
    }
  }
}
