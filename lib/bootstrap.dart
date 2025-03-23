import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:kite/util/app_bloc_observer.dart';
import 'package:kite/util/preferences.dart';
import 'package:logger/logger.dart';

Logger get log => Logger();

Future<void> _initPreference() async {
  final preferences = Preferences();
  await preferences.init();
  GetIt.I.registerSingleton(preferences);
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  final stopwatch = Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log.e(
      details.exceptionAsString(),
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  await _initPreference();

  stopwatch.stop();
  log.d('Bootstrap completed in ${stopwatch.elapsed}');
  runApp(await builder());
}
