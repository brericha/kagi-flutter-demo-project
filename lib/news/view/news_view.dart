import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kite/app/data/news_data.dart';
import 'package:kite/l10n/l10n.dart';
import 'package:kite/news/view/cluster_list.dart';
import 'package:kite/news/view/today_in_history_view.dart';
import 'package:kite/settings/cubit/settings_cubit.dart';
import 'package:kite/settings/view/settings_page.dart';
import 'package:logger/logger.dart';

class NewsView extends StatefulWidget {
  const NewsView(this.data, {super.key});

  final NewsData data;

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, settingsState) {
        Logger().d('listener: $settingsState');
        setState(() {});
      },
      builder: (context, settingsState) {
        final categories =
            settingsState.categories
              // Check if any categories are empty (meaning an error occurred
              // during deserialization)
              ..removeWhere((category) {
                if (category == 'Today in History') {
                  return widget.data.events.isEmpty;
                } else {
                  return widget.data.clusters[category]?.isEmpty ?? true;
                }
              });

        return DefaultTabController(
          length: categories.length,
          child: Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/kite.svg',
                  height: 10,
                  width: 10,
                ),
              ),
              title: Text(context.l10n.appTitle),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const SettingsPage(),
                        ),
                      ),
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: categories.map((e) => Tab(text: e)).toList(),
              ),
            ),
            body: TabBarView(
              children:
                  categories.map<Widget>((e) {
                    if (e == 'Today in History') {
                      return TodayInHistoryView(widget.data.events);
                    } else {
                      final cluster = widget.data.clusters[e];
                      if (cluster != null) {
                        return ClusterList(cluster);
                      } else {
                        // TODO(brericha): handle this
                        return Container();
                      }
                    }
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
