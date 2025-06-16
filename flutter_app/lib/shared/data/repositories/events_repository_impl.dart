import 'package:mongo_dart/mongo_dart.dart';

import 'package:ww1_map/features/timeline/domain/models/date_interval.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';
import 'package:ww1_map/shared/domain/models/map/rect_coordinates.dart';
import 'package:ww1_map/shared/domain/repositories/war_events_repository.dart';

class EventsRepositoryImpl extends EventsRepository {
  final Db _mongoDatabase;

  EventsRepositoryImpl({required Db mongoDatabase})
    : _mongoDatabase = mongoDatabase;

  @override
  Future<WarEvent?> getEventById(ObjectId id) async {
    final collection = _mongoDatabase.collection("events");
    final result = await collection.findOne({"_id": id});

    if (result == null) return null;
    return WarEvent.fromJsonBuilder(result);
  }

  @override
  Future<List<WarEvent>> getEvents({
    ObjectId? regimentId,
    DateInterval? interval,
    RectCoordinates? bounds,
    int? startAt,
    required int limit,
  }) async {
    final collection = _mongoDatabase.collection("events");

    final pipeline = AggregationPipelineBuilder();

    if (regimentId != null) {
      pipeline.addStage(Match({'regiment_id': regimentId}));
    }
    // if (interval != null) {
    //   pipeline
    //       .addStage(
    //         Match({
    //           'start_date': {r'$gte': interval.start},
    //         }),
    //       )
    //       .addStage(
    //         Match({
    //           'start_date': {r'$lte': interval.end},
    //         }),
    //       );
    // }
    // if (bounds != null) {
    //   pipeline.addStage(
    //     SetStage({
    //       'allPoints': {
    //         r'$switch': {
    //           'branches': [
    //             {
    //               'case': {r'$isArray': r'$coordinates'},
    //               'then': r'$coordinates',
    //             },
    //             {
    //               'case': {
    //                 r'$and': [
    //                   {r'$isArray': r'$coordinates.departure_point'},
    //                   {r'$isArray': r'$coordinates.arrival_point'},
    //                 ],
    //               },
    //               'then': {
    //                 r'$concatArrays': [
    //                   r'$coordinates.departure_point',
    //                   r'$coordinates.arrival_point',
    //                 ],
    //               },
    //             },
    //           ],
    //           'default': [],
    //         },
    //       },
    //     }),
    //   );
    //   pipeline.addStage(Unwind(Field('allPoints')));
    //   pipeline.addStage(
    //     Match({
    //       'allPoints.coordinates': {
    //         r'$geoWithin': {
    //           r'$box': [bounds.bottomRight.toList, bounds.topLeft.toList],
    //         },
    //       },
    //     }),
    //   );

    //   pipeline.addStage(
    //     Group(id: Field('_id'), fields: {'doc': First(Var.root)}),
    //   );
    //   pipeline.addStage(ReplaceRoot(Field('doc')));
    // }
    if (startAt != null && startAt != 0) {
      pipeline.addStage(Skip(startAt));
    }
    pipeline.addStage(Limit(limit));

    // print(pipeline.build());
    print("reposiotyEvents.getEvents() call");
    // print((await collection.aggregateToStream(pipeline.build()).toList()).length);
    final result =
        await collection.aggregateToStream(pipeline.build()).toList();
    return result.map(WarEvent.fromJsonBuilder).toList();
  }
}
