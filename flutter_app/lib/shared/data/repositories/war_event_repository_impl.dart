import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';
import 'package:ww1_map/shared/domain/repositories/war_events_repository.dart';

class WarEventRepositoryImpl extends WarEventsRepository {
  final Db _mongoDatabase;

  WarEventRepositoryImpl({required Db mongoDatabase})
    : _mongoDatabase = mongoDatabase;

  @override
  Future<WarEvent?> getEventById(ObjectId id) async {
    final collection = _mongoDatabase.collection("events");
    final result = await collection.findOne({"_id": id});

    if (result == null) return null;
    return WarEvent.fromJsonBuilder(result);
  }

  @override
  Future<List<WarEvent>> getEventsByRegiment({
    //pr le scroll sur la list des evenements.
    required ObjectId regimentId,
    int startAt = 0,
    int offset = 15,
  }) {
    throw Exception();
  }

  @override
  Future<List<WarEvent>> getEventsInArea({
    required GpsCoordinates bottomLeft,
    required GpsCoordinates topRight,
    ObjectId? regimentId,
  }) {
    throw Exception();
  }

  //get event sur une periode.
}
