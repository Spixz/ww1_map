import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/data/repositories/regiment_repository_impl.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env.dev");
  });

  test('Test getAllRegiments', () async {
    final db = await Db.create(dotenv.env['MONGO_URI']!);
    await db.open();
    expect(db, isA<Db>());

    final repo = RegimentRepositoryImpl(mongoDatabase: db);
    final allRegiments = await repo.getAllRegiments();
    expect(allRegiments, isNotEmpty);
  });

  test('Test getRegimentById', () async {
    final db = await Db.create(dotenv.env['MONGO_URI']!);
    await db.open();
    expect(db, isA<Db>());

    final repo = RegimentRepositoryImpl(mongoDatabase: db);
    final regiment = await repo.getRegimentById(ObjectId.fromHexString("68431760570a28785cf51fc0"));
    expect(regiment, isNotNull);
  });
}
