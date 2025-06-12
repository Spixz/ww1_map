import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/data/repositories/war_event_repository_impl.dart';
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

    final repo = WarEventRepositoryImpl(mongoDatabase: db);
    final militaryEvent = await repo.getEventById(
      ObjectId.fromHexString("6849a662f60a60c7da8f5f2e"),
    );
    // print(event?.toJson());
    expect(militaryEvent, isNotNull);
    expect(militaryEvent, isA<MilitaryEvent>);

    final unitMovmentEvent = await repo.getEventById(
      ObjectId.fromHexString("6846a877a71a3e29f15d8786"),
    );
    expect(unitMovmentEvent, isNotNull);
    expect(unitMovmentEvent, isA<UnitMovementEvent>());

    final politicalEvent = await repo.getEventById(
      ObjectId.fromHexString("684a7c2f54c065a0da25fcfc"),
    );
    expect(unitMovmentEvent, isNotNull);
    expect(politicalEvent, isA<PoliticalEvent>());
  });

  // test('Test getRegimentById', () async {
  //   final db = await Db.create(dotenv.env['MONGO_URI']!);
  //   await db.open();
  //   expect(db, isA<Db>());

  //   final repo = RegimentRepositoryImpl(mongoDatabase: db);
  //   final regiment = await repo.getRegimentById(ObjectId.fromHexString("68431760570a28785cf51fc0"));
  //   expect(regiment, isNotNull);
  // });
}
