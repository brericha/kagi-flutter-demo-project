import 'package:flutter/material.dart';
import 'package:kite/l10n/l10n.dart';
import 'package:kite_api_client/kite_api_client.dart';
import 'package:url_launcher/url_launcher.dart';

class Perspectives extends StatelessWidget {
  const Perspectives(this.perspectives, {super.key});

  final List<Perspective> perspectives;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          context.l10n.clusterPerspectives,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        ListView.builder(
          // physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: perspectives.length,
          itemBuilder: (context, index) {
            final item = perspectives[index];
            final parts = item.text.split(':');

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      parts[0].trim(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(parts[1].trim()),
                    TextButton(
                      onPressed:
                          () => launchUrl(Uri.parse(item.sources.first.url)),
                      child: Text(item.sources.first.name),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
