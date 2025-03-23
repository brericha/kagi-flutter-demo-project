import 'package:flutter/material.dart';
import 'package:kite/cluster/data/timeline_event.dart';
import 'package:kite/l10n/l10n.dart';
import 'package:kite/widget/timeline_list.dart';

class Timeline extends StatelessWidget {
  const Timeline(this.events, {super.key});

  final List<String> events;

  double get lineWidth => 2;

  @override
  Widget build(BuildContext context) {
    final parsedEvents = events.map(TimelineEvent.fromString).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          context.l10n.clusterTimeline,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        TimelineList(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: parsedEvents.length,
          contentLength: (context, index) {
            var length = 0;
            length += parsedEvents[index].date.length;
            length += parsedEvents[index].description.length;
            return length;
          },
          contentBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 6, left: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    parsedEvents[index].date,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(parsedEvents[index].description),
                ],
              ),
            );
          },
          nodeBuilder: (context, index) {
            return CircleAvatar(radius: 20, child: Text('${index + 1}'));
          },
        ),
      ],
    );
  }
}
