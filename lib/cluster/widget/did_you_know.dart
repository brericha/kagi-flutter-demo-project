import 'package:flutter/material.dart';
import 'package:kite/l10n/l10n.dart';

class DidYouKnow extends StatelessWidget {
  const DidYouKnow(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListTile(
          title: Text(context.l10n.clusterDidYouKnow),
          subtitle: Text(message),
        ),
      ),
    );
  }
}
