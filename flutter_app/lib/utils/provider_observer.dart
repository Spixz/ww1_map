import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyObserver extends ProviderObserver {
  @override
  // void didAddProvider(
  //   ProviderBase<Object?> provider,
  //   Object? value,
  //   ProviderContainer container,
  // ) {
  //   print(
  //     "Provider $provider (${provider.name}) was initialized with $value",
  //   );
  // }

  // @override
  // void didDisposeProvider(
  //   ProviderBase<Object?> provider,
  //   ProviderContainer container,
  // ) {
  //   print('Provider $provider (${provider.name}) was disposed');
  // }

  // @override
  // void didUpdateProvider(
  //   ProviderBase<Object?> provider,
  //   Object? previousValue,
  //   Object? newValue,
  //   ProviderContainer container,
  // ) {
  //   print('Provider $provider updated from $previousValue to $newValue');
  // }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    debugPrint(
      '❌ Erreur dans Provider `${provider.name ?? provider.runtimeType}`',
    );
    debugPrint('$error');
    debugPrint('$stackTrace');
  }
}
