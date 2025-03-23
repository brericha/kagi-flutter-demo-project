import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Display a quote.
class Quote extends StatelessWidget {
  const Quote({
    required this.quote,
    required this.quoteAuthor,
    required this.quoteSource,
    required this.quoteSourceUrl,
    super.key,
  });

  final String quote;
  final String quoteAuthor;
  final String quoteSource;
  final String quoteSourceUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(quote, style: Theme.of(context).textTheme.bodyLarge),
            TextButton(
              onPressed: () {
                launchUrl(Uri.parse(quoteSourceUrl));
              },
              child: Text('$quoteAuthor (via $quoteSource)'),
            ),
          ],
        ),
      ),
    );
  }
}
