import 'package:flutter/material.dart';
import 'package:kite/l10n/l10n.dart';

/// Display a list of enumerated talking points/highlights
class Highlights extends StatelessWidget {
  const Highlights(this.talkingPoints, {super.key});

  final List<String> talkingPoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.clusterHighlights,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Divider(),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: talkingPoints.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final talkingPoint = talkingPoints[index].split(':');

            final String header;
            final String body;

            // Support possible talking point without the "header: body"  format
            if (talkingPoint.length == 1) {
              header = '';
              body = talkingPoint[0];
            } else {
              header = talkingPoint[0];
              body = talkingPoint[1];
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        header,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                Text(body.trim(), style: Theme.of(context).textTheme.bodyLarge),
              ],
            );
          },
        ),
      ],
    );
  }
}
