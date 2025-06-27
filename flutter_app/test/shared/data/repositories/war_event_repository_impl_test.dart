import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/data/repositories/events_repository_mongo_impl.dart';
import 'package:ww1_map/shared/domain/models/events/military_event.dart';
import 'package:ww1_map/shared/domain/models/events/political_event.dart';
import 'package:ww1_map/shared/domain/models/events/unit_movement_event.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env.dev");
  });

  test('Test eventById', () async {
    final db = await Db.create(dotenv.env['MONGO_URI']!);
    await db.open();
    expect(db, isA<Db>());

    final repo = EventsRepositoryMongoImpl(mongoDatabase: db);
    final militaryEvent = await repo.getEventById(
      ObjectId.fromHexString("6846a945a71a3e29f15d8793"),
    );
    // print(event?.toJson());
    expect(militaryEvent, isNotNull);
    expect(militaryEvent, isA<MilitaryEvent>());

    final unitMovmentEvent = await repo.getEventById(
      ObjectId.fromHexString("6846a877a71a3e29f15d8786"),
    );
    expect(unitMovmentEvent, isNotNull);
    expect(unitMovmentEvent, isA<UnitMovementEvent>());

    final politicalEvent = await repo.getEventById(
      ObjectId.fromHexString("6846a877a71a3e29f15d8784"),
    );
    expect(unitMovmentEvent, isNotNull);
    expect(politicalEvent, isA<PoliticalEvent>());
  });

  test('Test eventById for military event', () async {
    final db = await Db.create(dotenv.env['MONGO_URI']!);
    await db.open();
    expect(db, isA<Db>());

    final repo = EventsRepositoryMongoImpl(mongoDatabase: db);

    final militaryEvent = await repo.getEventById(
      ObjectId.fromHexString("6846a945a71a3e29f15d8793"),
    );
    expect(militaryEvent, isNotNull);
    expect(militaryEvent, isA<MilitaryEvent>());
  });

  test('Test eventById for unit movement', () async {
    final db = await Db.create(dotenv.env['MONGO_URI']!);
    await db.open();
    expect(db, isA<Db>());

    final repo = EventsRepositoryMongoImpl(mongoDatabase: db);

    final unitMovementEvent = await repo.getEventById(
      ObjectId.fromHexString("6846aa01a71a3e29f15d87b1"),
    );
    expect(unitMovementEvent, isNotNull);
    expect(unitMovementEvent, isA<UnitMovementEvent>());
    print(unitMovementEvent);

  });
}
