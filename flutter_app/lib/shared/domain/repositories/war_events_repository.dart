import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';

abstract class WarEventsRepository {
  Future<WarEvent?> getEventById(ObjectId id);
  Future<List<WarEvent>> getEventsByRegiment({
    //pr le scroll sur la list des evenements.
    required ObjectId regimentId,
    required int startAt,
    required int offset,
  });
  Future<List<WarEvent>> getEventsInArea({
    required GpsCoordinates bottomLeft,
    required GpsCoordinates topRight,
    ObjectId? regimentId,
  });
  //get event sur une periode.
  //get event sur une surface
  //get event sur un regiment
}
