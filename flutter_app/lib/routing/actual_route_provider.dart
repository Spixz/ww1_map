import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/routing/routes_name.dart';


final actualRouteProvider = StateProvider<SingleRoute>(
  (ref) => Routes.home,
);
