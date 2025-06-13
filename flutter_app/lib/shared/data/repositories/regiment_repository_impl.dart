import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/domain/models/regiments/regiment.dart';
import 'package:ww1_map/shared/domain/repositories/regiment_repository.dart';

class RegimentRepositoryImpl implements RegimentRepository {
  final Db _mongoDatabase;

  const RegimentRepositoryImpl({required Db mongoDatabase})
    : _mongoDatabase = mongoDatabase;

  @override
  Future<Regiment?> getRegimentById(ObjectId id) async {
    final collection = _mongoDatabase.collection("regiments");
    final response = await collection.findOne({"_id": id});
    return response != null ? Regiment.fromJson(response) : null;
  }

  @override
  Future<List<Regiment>> getAllRegiments({
    SortRegimentBy sortBy = SortRegimentBy.name,
  }) async {
    final sort =
        (sortBy == SortRegimentBy.name)
            ? where.sortBy("title").limit(100)
            : where.sortBy("description", descending: true).limit(100);
    final collection = _mongoDatabase.collection("regiments");
    final response = await collection.find(sort) .toList();
    return response.map(Regiment.fromJson).toList();
  }

  @override
  Future<List<Regiment>> searchRegiments(String query) async {
    final collection = _mongoDatabase.collection("regiments");
    final response =
        await collection
            .find(where.match('title', query, caseInsensitive: true))
            .toList();
    return response.map(Regiment.fromJson).toList();
  }
}
