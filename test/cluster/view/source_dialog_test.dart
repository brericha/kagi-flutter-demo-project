import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/view/source_dialog.dart';
import 'package:kite_api_client/kite_api_client.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SourceDialog', () {
    late Domain domain;
    late List<Article> articles;

    setUp(() {
      domain = const Domain('example.com', 'https://example.com/favicon.ico');
      articles = [
        const Article(
          title: 'Test Article 1',
          link: 'https://example.com/article1',
          domain: 'example.com',
        ),
        const Article(
          title: 'Test Article 2',
          link: 'https://example.com/article2',
          domain: 'example.com',
        ),
      ];
    });

    testWidgets('renders correctly', (tester) async {
      await mockNetworkImages(
        () async => tester.pumpApp(
          Material(child: SourceDialog(domain: domain, articles: articles)),
        ),
      );

      // Verify domain information is displayed
      expect(find.text('example.com'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      // Verify articles are displayed
      expect(find.text('Test Article 1'), findsOneWidget);
      expect(find.text('Test Article 2'), findsOneWidget);
      expect(find.byIcon(Icons.open_in_browser), findsNWidgets(2));
    });

    testWidgets('shows using static show method', (tester) async {
      await mockNetworkImages(
        () async => tester.pumpApp(
          Material(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed:
                      () => SourceDialog.show(
                        context,
                        domain: domain,
                        articles: articles,
                      ),
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // Tap button to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.byType(SourceDialog), findsOneWidget);
      expect(find.text('example.com'), findsOneWidget);
      expect(find.text('Test Article 1'), findsOneWidget);
      expect(find.text('Test Article 2'), findsOneWidget);
    });
  });
}
