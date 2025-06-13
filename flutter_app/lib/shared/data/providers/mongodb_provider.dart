import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_dart/mongo_dart.dart';

final mongoDbProvider = FutureProvider((ref) async {
  final mongoUri = dotenv.get("MONGO_URI", fallback: "");
  final db = await Db.create(mongoUri);
  await db.open();
  return db;
});
