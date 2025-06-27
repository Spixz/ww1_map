import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:ww1_map/features/timeline/domain/models/date_interval.dart';
import 'package:ww1_map/shared/data/repositories/events_repository_mongo_impl.dart';
import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';
import 'package:ww1_map/shared/domain/models/events/war_event.dart';
import 'package:ww1_map/shared/domain/models/map/rect_coordinates.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env.dev");
  });

  test('Test get events by id', () async {
    final db = await Db.create(dotenv.env['MONGO_URI']!);
    await db.open();
    expect(db, isA<Db>());

    final repo = EventsRepositoryMongoImpl(mongoDatabase: db);
    final result = await repo.getEventById(
      ObjectId.fromHexString("6846a945a71a3e29f15d8793"),
    );
    expect(result, isNotNull);
    expect(result?.startDate, isNotNull);
  });

  test('Test get events by regiment id', () async {
    final db = await Db.create(dotenv.env['MONGO_URI']!);
    await db.open();
    expect(db, isA<Db>());

    final repo = EventsRepositoryMongoImpl(mongoDatabase: db);
    final result = await repo.getEvents(
      regimentId: ObjectId.fromHexString("68431760570a28785cf51fbc"),
      limit: 15,
    );
    expect(result, isNotEmpty);
  });

  test('Test get events by regiment id and date', () async {
    final db = await Db.create(dotenv.env['MONGO_URI']!);
    await db.open();
    expect(db, isA<Db>());

    final repo = EventsRepositoryMongoImpl(mongoDatabase: db);

    var result = await repo.getEvents(
      regimentId: ObjectId.fromHexString("68431760570a28785cf51fbc"),
      interval: DateInterval.today(day: DateTime(1914, 08, 15)),
      limit: 15,
    );
    expect(result.length, 2);
  });

  test('Test get events by location (military event)', () async {
    final db = await Db.create(dotenv.env['MONGO_URI']!);
    await db.open();
    expect(db, isA<Db>());

    final repo = EventsRepositoryMongoImpl(mongoDatabase: db);
    final result = await repo.getEvents(
      bounds: RectCoordinates(
        bottomLeft: GpsCoordinates(
          latitude: 50.16568536560905,
          longitude: -3.302049351782936,
        ),
        topRight: GpsCoordinates(
          latitude: 43.68218312650164,
          longitude: 5.555377906005663,
        ),
      ),
      limit: 15,
    );
    expect(result, isNotEmpty);
  });
}

void printEvents(List<WarEvent> events) {
  events.forEach((elem) => print(elem.title));
}
