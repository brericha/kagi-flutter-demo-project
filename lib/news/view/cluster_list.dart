import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kite/cluster/view/cluster_detail_page.dart';
import 'package:kite/l10n/l10n.dart';
import 'package:kite/settings/cubit/settings_cubit.dart';
import 'package:kite_api_client/kite_api_client.dart';

class ClusterList extends StatefulWidget {
  const ClusterList(this.clusters, {super.key});

  final List<Cluster> clusters;

  @override
  State<ClusterList> createState() => _ClusterListState();
}

class _ClusterListState extends State<ClusterList> {
  final _categoryColors = <Color>[
    const Color(0xFFCC3333),
    const Color(0xFFB85C2E),
    const Color(0xFF0077CC),
    const Color(0xFF666633),
    const Color(0xFF8822CC),
    const Color(0xFFB8288F),
    const Color(0xFFE60039),
    const Color(0xFF00855A),
    const Color(0xFFD14900),
  ];

  Color _getCategoryColor(String category) {
    final number =
        (category.codeUnitAt(0) + category.codeUnitAt(1) + category.length) % 9;

    return _categoryColors[number];
  }

  Offset _lastTapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return ListView.separated(
          itemCount: widget.clusters.length,
          separatorBuilder: (_, __) => const Divider(),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          itemBuilder: (context, index) {
            final cluster = widget.clusters[index];

            final isRead = state.readStories.containsKey(cluster.title);

            return InkWell(
              onTap: () {
                // Mark cluster as read
                context.settingsCubit.addReadStory(cluster.title);

                // show ClusterDetailPage
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ClusterDetailPage(cluster),
                  ),
                );
              },
              onTapDown: (details) => _lastTapPosition = details.globalPosition,
              onLongPress: () {
                final overlay =
                    Overlay.of(context).context.findRenderObject()
                        as RenderBox?;

                if (overlay != null) {
                  showMenu<int>(
                    context: context,
                    position: RelativeRect.fromRect(
                      _lastTapPosition & const Size(40, 40),
                      Offset.zero & overlay.size,
                    ),
                    items: [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(
                          isRead
                              ? context.l10n.markUnread
                              : context.l10n.markRead,
                        ),
                      ),
                    ],
                  ).then((result) {
                    if (result == 0 && context.mounted) {
                      context.settingsCubit.toggleReadStory(cluster.title);
                    }
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      cluster.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getCategoryColor(cluster.category),
                      ),
                    ),
                    Text(
                      cluster.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
