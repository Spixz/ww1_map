import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/shared/data/providers/regiment_repository_provider.dart';
import 'package:ww1_map/shared/domain/models/regiments/regiment.dart';
import 'package:ww1_map/shared/domain/repositories/regiment_repository.dart';

final allRegimentsProvider =
    FutureProviderFamily<List<Regiment>, SortRegimentBy?>((ref, sortBy) {
      final regimentProvider = ref.watch(regimentRepositoryImplProvider);
      return regimentProvider.getAllRegiments(
        sortBy: sortBy ?? SortRegimentBy.name,
      );
    });
