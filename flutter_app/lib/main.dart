import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/core/scroll_behavior.dart';
import 'package:ww1_map/core/theme.dart';
import 'package:ww1_map/features/launching_screen/view/pages/app_loading_failed_screen.dart';
import 'package:ww1_map/features/launching_screen/view/pages/splash_screen.dart';
import 'package:ww1_map/routing/router.dart';
import 'package:ww1_map/shared/data/providers/mongodb_provider.dart';
import 'package:ww1_map/utils/provider_observer.dart';

void main() async {
  final envFilepath = kDebugMode ? '.env.dev' : '.env.prod';
  await dotenv.load(fileName: envFilepath);

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('fr'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: Locale('fr'),
      child: ProviderScope(observers: [MyObserver()], child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseProvider = ref.watch(mongoDbProvider);

    return databaseProvider.when(
      data:
          (_) => MaterialApp.router(
            theme: ww1Theme,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            scrollBehavior: AppCustomScrollBehavior(),
            routerConfig: createRouter(ref),
          ),
      error: (_, __) => AppLoadingFailedScreen(),
      loading: () => const SplashScreen(),
    );
  }
}
