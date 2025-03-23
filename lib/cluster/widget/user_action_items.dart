import 'package:flutter/material.dart';
import 'package:kite/l10n/l10n.dart';

class UserActionItems extends StatelessWidget {
  const UserActionItems(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final subtitle = items.map((line) => '• $line').join('\n');

    return Card(
      color: Theme.of(context).colorScheme.surfaceDim,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListTile(
          title: Text(context.l10n.clusterActionItems),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}
