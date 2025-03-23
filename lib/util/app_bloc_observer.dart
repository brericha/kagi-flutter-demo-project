import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  Logger get log => Logger();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log.d('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log.e(
      'onError(${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
