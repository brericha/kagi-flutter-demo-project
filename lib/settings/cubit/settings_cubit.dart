import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kite/util/preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState.empty()) {
    // Emit initial settings
    emit(
      state.copyWith(
        categories: _preferences.categories,
        themeMode: _preferences.themeMode,
        readStories: _preferences.readStories,
        numStoriesRead: _preferences.numStoriesRead,
      ),
    );

    _pruneReadStories();
  }

  final _preferences = GetIt.I.get<Preferences>();

  void setCategories(List<String> categories) {
    _preferences.categories = categories;
    emit(state.copyWith(categories: categories));
  }

  void setThemeMode(ThemeMode themeMode) {
    _preferences.themeMode = themeMode;
    emit(state.copyWith(themeMode: themeMode));
  }

  void addReadStory(String title) {
    final readStories = Map<String, DateTime>.from(state.readStories);
    readStories[title] = DateTime.now();
    _preferences.readStories = readStories;
    _preferences.numStoriesRead++;
    emit(
      state.copyWith(
        readStories: readStories,
        numStoriesRead: _preferences.numStoriesRead,
      ),
    );
  }

  void removeReadStory(String title) {
    final readStories = Map<String, DateTime>.from(state.readStories)
      ..removeWhere((key, value) => key == title);
    _preferences.readStories = readStories;
    _preferences.numStoriesRead--;
    emit(
      state.copyWith(
        readStories: readStories,
        numStoriesRead: _preferences.numStoriesRead,
      ),
    );
  }

  void toggleReadStory(String title) {
    if (state.readStories.containsKey(title)) {
      removeReadStory(title);
    } else {
      addReadStory(title);
    }
  }

  /// Remove entries that are more than 2 days old as those stories are
  /// certainly gone by now in order to keep the map from growing too large
  void _pruneReadStories() {
    final now = DateTime.now();
    final readStories = Map<String, DateTime>.from(state.readStories)
      ..removeWhere((key, value) => value.difference(now).inDays > 2);
    _preferences.readStories = readStories;
    emit(state.copyWith(readStories: readStories));
  }
}

extension SettingsCubitExt on BuildContext {
  SettingsCubit get settingsCubit => BlocProvider.of<SettingsCubit>(this);
  SettingsState get settingsState => settingsCubit.state;
}
