import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kite/app/data/news_data.dart';
import 'package:kite_api_client/kite_api_client.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial()) {
    load();
  }

  final _client = KiteApiClient();

  /// Load news data from the API.
  Future<void> load() async {
    emit(state.copyWith(loading: true, error: () => null));

    try {
      // Get all categories
      final categories = await _client.getCategories();
      final categoryResponses =
          await Future.wait(categories.map((e) => _client.getCategory(e.file)));

      final clusters = <String, List<Cluster>>{};
      for (final c in categoryResponses) {
        clusters[c.category] = c.clusters;
      }

      final events = await _client.getEvents();

      emit(
        state.copyWith(
          loading: false,
          error: () => null,
          data: () => NewsData(
            categories: categories,
            clusters: clusters,
            events: events,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(loading: false, error: () => e, data: () => null));
    }
  }
}

extension AppCubitExt on BuildContext {
  AppCubit get appCubit => BlocProvider.of<AppCubit>(this);
  AppState get appState => appCubit.state;
}
