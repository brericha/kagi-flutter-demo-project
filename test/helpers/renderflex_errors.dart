import 'package:flutter/material.dart';

// https://itnext.io/widget-testing-dealing-with-renderflex-overflow-errors-9488f9cf9a29
void ignoreOverflowErrors(
  FlutterErrorDetails details, {
  bool forceReport = false,
}) {
  var ifIsOverflowError = false;
  var isUnableToLoadAsset = false;

  // Detect overflow error.
  final exception = details.exception;
  if (exception is FlutterError) {
    ifIsOverflowError =
        !exception.diagnostics.any(
          (e) => e.value.toString().startsWith('A RenderFlex overflowed by'),
        );
    isUnableToLoadAsset =
        !exception.diagnostics.any(
          (e) => e.value.toString().startsWith('Unable to load asset'),
        );
  }

  // Ignore if is overflow error.
  if (ifIsOverflowError || isUnableToLoadAsset) {
    debugPrint('Ignored RenderFlex overflow error');
  } else {
    FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
  }
}
