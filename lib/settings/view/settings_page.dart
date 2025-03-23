import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kite/l10n/l10n.dart';
import 'package:kite/settings/cubit/settings_cubit.dart';
import 'package:kite/settings/view/category_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.settingsTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: context.l10n.settingsTabGeneral),
              Tab(text: context.l10n.settingsTabCategories),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GeneralSettings(),
            CategorySettings(),
          ],
        ),
      ),
    );
  }
}

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ThemeModeSetting(state.themeMode),
            ],
          ),
        );
      },
    );
  }
}

class ThemeModeSetting extends StatelessWidget {
  const ThemeModeSetting(this.themeMode, {super.key});

  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    final String subtitle;
    switch (themeMode) {
      case ThemeMode.system:
        subtitle = context.l10n.settingsThemeSystem;
      case ThemeMode.light:
        subtitle = context.l10n.settingsThemeLight;
      case ThemeMode.dark:
        subtitle = context.l10n.settingsThemeDark;
    }

    return ListTile(
      title: Text(context.l10n.settingsTheme),
      subtitle: Text(subtitle),
      onTap: () async {
        final value = await showDialog<ThemeMode>(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(context.l10n.settingsTheme),
              children: [
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, ThemeMode.system),
                  child: Text(context.l10n.settingsThemeSystem),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, ThemeMode.light),
                  child: Text(context.l10n.settingsThemeLight),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, ThemeMode.dark),
                  child: Text(context.l10n.settingsThemeDark),
                ),
              ],
            );
          },
        );

        if (value != null && context.mounted) {
          context.settingsCubit.setThemeMode(value);
        }
      },
    );
  }
}
