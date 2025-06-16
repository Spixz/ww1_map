import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/features/right_pane/providers/selected_regiment_id_notifier.dart';
import 'package:ww1_map/shared/data/providers/regiment_repository_impl_provider.dart';
import 'package:ww1_map/shared/domain/models/regiments/regiment.dart';

final selectedRegimentProvider = FutureProvider<Regiment?>((ref) {
  final regimentRepository = ref.watch(regimentRepositoryImplProvider);
  final selectedRegimentId = ref.watch(selectedRegimentIdProvider);

  if (selectedRegimentId != null) {
    return regimentRepository.getRegimentById(selectedRegimentId);
  }
  return null;
});
