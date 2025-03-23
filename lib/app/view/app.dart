import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kite/app/cubit/app_cubit.dart';
import 'package:kite/app/view/error_view.dart';
import 'package:kite/app/view/loading_view.dart';
import 'package:kite/l10n/l10n.dart';
import 'package:kite/news/view/news_view.dart';
import 'package:kite/settings/cubit/settings_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => AppCubit()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFFFB319),
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFFFB319),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: settingsState.themeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                if (state.loading) {
                  return const LoadingView();
                } else if (state.error != null) {
                  return ErrorView(
                    error: state.error!,
                    onRetryPressed: context.appCubit.load, // Try loading again
                  );
                } else if (state.data != null) {
                  return NewsView(state.data!);
                } else {
                  // Invalid state
                  // TODO(brericha): handle this
                  return Container();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
