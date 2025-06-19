import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/shared/data/providers/mongodb_provider.dart';
import 'package:ww1_map/shared/data/repositories/events_repository_impl.dart';

final eventsRepositoryImplProvider = Provider((ref) {
  final mongodbProvider = ref.watch(mongoDbProvider).asData!;
  
  return EventsRepositoryImpl(mongoDatabase: mongodbProvider.value);
});