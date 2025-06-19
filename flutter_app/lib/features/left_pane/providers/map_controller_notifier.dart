import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapControllerProvider = NotifierProvider(MapControllerNotifier.new);

class MapControllerNotifier extends Notifier<MapController> {
  bool isReady = false;

  @override
  MapController build() => MapController();

  MapController? get get => isReady ? state : null;

  void declareReady() => isReady = true;
  void dispose() => state.dispose();
}
