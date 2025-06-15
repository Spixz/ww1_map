import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/shared/domain/models/events/gps_coordinates.dart';
import 'package:ww1_map/shared/domain/models/map/map_informations.dart';
import 'package:ww1_map/shared/domain/models/map/rect_coordinates.dart';

final mapInformationsProvider = NotifierProvider(MapInformationsNotifier.new);

class MapInformationsNotifier extends Notifier<MapInformations> {
  @override
  build() => EmptyMapInformations();

  void update({GpsCoordinates? center, RectCoordinates? bounds}) =>
      state = state.copyWith(center: center, bounds: bounds);
}
