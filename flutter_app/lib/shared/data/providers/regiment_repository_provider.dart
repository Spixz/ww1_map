import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/shared/data/providers/mongodb_provider.dart';
import 'package:ww1_map/shared/data/repositories/regiment_repository_impl.dart';

final regimentRepositoryImplProvider = Provider((ref) {
  final mongodbProvider = ref.watch(mongoDbProvider).asData!;
  return RegimentRepositoryImpl(mongoDatabase: mongodbProvider.value);
});