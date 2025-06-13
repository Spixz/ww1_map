import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/data/providers/regiment_repository_provider.dart';
import 'package:ww1_map/shared/domain/models/regiments/regiment.dart';

final selectedRegimentIdProvider = StateProvider<ObjectId?>(
  (ref) => ObjectId.fromHexString("68431760570a28785cf51fbc"),
);

final selectedRegimentProvider = FutureProvider<Regiment?>((ref) {
  final regimentRepository = ref.watch(regimentRepositoryImplProvider);
  final selectedRegimentId = ref.watch(selectedRegimentIdProvider);

  if (selectedRegimentId != null) {
    return regimentRepository.getRegimentById(selectedRegimentId);
  }
  return null;
});
