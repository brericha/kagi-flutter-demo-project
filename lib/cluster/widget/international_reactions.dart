import 'package:flutter/material.dart';
import 'package:kite/l10n/l10n.dart';

class InternationalReactions extends StatelessWidget {
  const InternationalReactions(this.data, {super.key});

  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.clusterInternationalReactions,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final item = data[index].split(':');
            final title = item[0].trim();
            final body = item[1].trim();

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(body),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
