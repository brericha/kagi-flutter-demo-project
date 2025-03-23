part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.categories,
    required this.themeMode,
    required this.readStories,
    required this.numStoriesRead,
  });

  factory SettingsState.empty() => const SettingsState(
    categories: [],
    themeMode: ThemeMode.system,
    readStories: {},
    numStoriesRead: 0,
  );

  final List<String> categories;
  final ThemeMode themeMode;
  final Map<String, DateTime> readStories;
  final int numStoriesRead;

  SettingsState copyWith({
    List<String>? categories,
    ThemeMode? themeMode,
    Map<String, DateTime>? readStories,
    int? numStoriesRead,
  }) {
    return SettingsState(
      categories:
          categories != null ? List<String>.from(categories) : this.categories,
      themeMode: themeMode ?? this.themeMode,
      readStories: readStories ?? this.readStories,
      numStoriesRead: numStoriesRead ?? this.numStoriesRead,
    );
  }

  @override
  List<Object> get props => [
    categories,
    themeMode,
    readStories,
    numStoriesRead,
  ];
}
