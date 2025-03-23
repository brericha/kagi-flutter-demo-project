part of 'app_cubit.dart';

class AppState extends Equatable {
  const AppState({
    required this.loading,
    this.error,
    this.data,
  });

  factory AppState.initial() => const AppState(loading: true);

  final bool loading;
  final Exception? error;
  final NewsData? data;

  /// Create a copy of this [AppState] with the specified new values.
  AppState copyWith({
    bool? loading,
    Exception? Function()? error,
    NewsData? Function()? data,
  }) {
    return AppState(
      loading: loading ?? this.loading,
      error: error != null ? error() : this.error,
      data: data != null ? data() : this.data,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        data,
      ];
}
