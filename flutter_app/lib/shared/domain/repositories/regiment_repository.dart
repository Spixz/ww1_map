import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/domain/models/regiments/regiment.dart';

enum SortRegimentBy { name, eventsAvailibility }

abstract class RegimentRepository {
  Future<Regiment?> getRegimentById(ObjectId id);
  Future<List<Regiment>> getAllRegiments({required SortRegimentBy sortBy});
  Future<List<Regiment>> searchRegiments(String query);
}
