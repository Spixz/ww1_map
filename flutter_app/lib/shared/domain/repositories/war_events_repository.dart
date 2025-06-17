import 'package:mongo_dart/mongo_dart.dart';

import 'package:ww1_map/features/timeline/domain/models/date_interval.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';
import 'package:ww1_map/shared/domain/models/map/rect_coordinates.dart';

abstract class EventsRepository {
  Future<WarEvent?> getEventById(ObjectId id);

  Future<List<WarEvent>> getEvents({
    ObjectId? regimentId,
    DateInterval? interval,
    DateTime? after,
    DateTime? before,
    RectCoordinates? bounds,
    int? offset,
    required int limit,
  });
}
