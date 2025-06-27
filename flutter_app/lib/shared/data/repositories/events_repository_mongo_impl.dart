import 'package:mongo_dart/mongo_dart.dart';

import 'package:ww1_map/features/timeline/domain/models/date_interval.dart';
import 'package:ww1_map/shared/data/mappers/rect_coordinates_to_mongobox.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';
import 'package:ww1_map/shared/domain/models/map/rect_coordinates.dart';
import 'package:ww1_map/shared/domain/repositories/war_events_repository.dart';

class EventsRepositoryMongoImpl extends EventsRepository {
  final Db _mongoDatabase;

  EventsRepositoryMongoImpl({required Db mongoDatabase})
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
    DateTime? after,
    DateTime? before,
    RectCoordinates? bounds,
    int? offset,
    required int limit,
  }) async {
    final collection = _mongoDatabase.collection("events");

    final pipeline = AggregationPipelineBuilder();
    pipeline.addStage(
      Match({
        "start_date": {r"$ne": null},
      }),
    );

    if (regimentId != null) {
      pipeline.addStage(Match({'regiment_id': regimentId}));
    }
    if (after != null) {
      pipeline.addStage(
        Match({
          'start_date': {r'$gte': after},
        }),
      );
    }
    if (before != null) {
      pipeline.addStage(
        Match({
          'start_date': {r'$lte': before},
        }),
      );
    }
    if (interval != null) {
      pipeline
          .addStage(
            Match({
              'start_date': {r'$gte': interval.start},
            }),
          )
          .addStage(
            Match({
              'start_date': {r'$lte': interval.end},
            }),
          );
    }
    if (bounds != null) {
      pipeline.addStage(
        SetStage({
          'allPoints': {
            r'$switch': {
              'branches': [
                {
                  'case': {r'$isArray': r'$coordinates'},
                  'then': r'$coordinates',
                },
                {
                  'case': {
                    r'$and': [
                      {r'$isArray': r'$coordinates.departure_point'},
                      {r'$isArray': r'$coordinates.arrival_point'},
                    ],
                  },
                  'then': {
                    r'$concatArrays': [
                      r'$coordinates.departure_point',
                      r'$coordinates.arrival_point',
                    ],
                  },
                },
              ],
              'default': [],
            },
          },
        }),
      );
      pipeline.addStage(Unwind(Field('allPoints')));
      pipeline.addStage(
        Match({
          'allPoints.coordinates': {
            r'$geoWithin': {r'$box': bounds.toMongoBox()},
          },
        }),
      );

      pipeline.addStage(
        Group(id: Field('_id'), fields: {'doc': First(Var.root)}),
      );
      pipeline.addStage(ReplaceRoot(Field('doc')));
    }

    pipeline.addStage(Sort({'start_date': 1}));

    if (offset != null && offset != 0) {
      pipeline.addStage(Skip(offset));
    }
    pipeline.addStage(Limit(limit));

    // print(pipeline.build());
    // print((await collection.aggregateToStream(pipeline.build()).toList()).length);
    final result =
        await collection.aggregateToStream(pipeline.build()).toList();

    return result.map(WarEvent.fromJsonBuilder).toList();
  }
}
