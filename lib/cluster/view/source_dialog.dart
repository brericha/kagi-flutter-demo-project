import 'package:flutter/material.dart';
import 'package:kite_api_client/kite_api_client.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceDialog extends StatelessWidget {
  const SourceDialog({required this.domain, required this.articles, super.key});

  static Future<void> show(
    BuildContext context, {
    required Domain domain,
    required List<Article> articles,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SourceDialog(domain: domain, articles: articles);
      },
    );
  }

  final Domain domain;
  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Image.network(
                  domain.favicon,
                  width: 24,
                  height: 24,
                  fit: BoxFit.fill,
                ),
                Expanded(
                  child: Text(
                    domain.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...List<Widget>.generate(articles.length, (index) {
              final article = articles[index];
              return ListTile(
                onTap: () => launchUrl(Uri.parse(article.link)),
                title: Text(
                  article.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.open_in_browser),
              );
            }),
            // Possible location for source information from media_data.json
            // ExpansionTile(
            //   title: const Text('Source information'),
            //   children: [
            //     Row(children: [Column(children: []), Column(children: [])]),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
