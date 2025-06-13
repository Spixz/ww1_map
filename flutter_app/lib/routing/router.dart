import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ww1_map/features/home/view/page/home_screen.dart';
import 'package:ww1_map/routing/actual_route_provider.dart';
import 'package:ww1_map/routing/routes_name.dart';

final initialLocation = Routes.home;

GoRouter createRouter(WidgetRef ref) => GoRouter(
  initialLocation: initialLocation.path,
  debugLogDiagnostics: true,
  // observers: [MyNavigatorObserver(ref)],
  routes: [
    GoRoute(
      path: Routes.home.path,
      name: Routes.home.name,
      builder: (context, state) {
        return const HomePage();
      },
    ),
    // GoRoute(
    //   path: Routes.createCard.path,
    //   name: Routes.createCard.name,
    //   builder: (context, state) {
    //     final CardModel card = state.extra as CardModel;
    //     return CreateCardScreen(cardToCreate: card);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.review.path,
    //   name: Routes.review.name,
    //   builder: (context, state) {
    //     final title = state.pathParameters['title'] ?? context.tr("Review");
    //     return ReviewScreen(title: title);
    //   },
    // ),
    // GoRoute(
    //   path: Routes.progress.path,
    //   name: Routes.progress.name,
    //   pageBuilder: (context, state) {
    //     return const NoTransitionPage(child: ProgressScreen());
    //   },
    // ),
  ],
  redirect: (context, state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final actualRoute = Routes.all.firstWhere(
        (route) => route.path == state.fullPath,
        orElse: () => initialLocation,
      );
      ref.read(actualRouteProvider.notifier).state = actualRoute;
    });
    return null;
  },
);
