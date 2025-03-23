import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/view/source_dialog.dart';
import 'package:kite/cluster/widget/sources.dart';
import 'package:kite_api_client/kite_api_client.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Sources', () {
    final articles = [
      const Article(
        title: 'Article 1',
        link: 'https://example.com/1',
        domain: 'example.com',
      ),
      const Article(
        title: 'Article 2',
        link: 'https://example.com/2',
        domain: 'example.com',
      ),
      const Article(
        title: 'Article 3',
        link: 'https://test.com/1',
        domain: 'test.com',
      ),
    ];

    final domains = [
      const Domain('example.com', 'https://example.com/favicon.ico'),
      const Domain('test.com', 'https://test.com/favicon.ico'),
    ];

    testWidgets('renders Sources with collapsed view', (tester) async {
      await mockNetworkImages(
        () async => tester.pumpApp(
          Material(child: Sources(articles: articles, domains: domains)),
        ),
      );

      // Verify title is visible
      expect(find.text('Sources'), findsOneWidget);

      // Verify correct number of domains visible in collapsed state
      expect(find.text('example.com'), findsOneWidget);
      expect(find.text('test.com'), findsOneWidget);

      // Verify article counts
      expect(find.text('2 articles'), findsOneWidget);
      expect(find.text('1 article'), findsOneWidget);
    });

    testWidgets('expands and collapses when tapped', (tester) async {
      FlutterError.onError = ignoreOverflowErrors;

      // Create a list with more domains to test expansion
      final largeList = List.generate(
        8,
        (i) => Domain('domain$i.com', 'https://domain$i.com/favicon.ico'),
      );

      final largeArticles = List.generate(
        8,
        (i) => Article(
          title: 'Article $i',
          link: 'https://domain$i.com/article',
          domain: 'domain$i.com',
        ),
      );

      await mockNetworkImages(
        () async => tester.pumpApp(
          Material(child: Sources(articles: largeArticles, domains: largeList)),
        ),
      );

      // Initially shows only 6 domains in collapsed state
      expect(find.text('domain0.com'), findsOneWidget);
      expect(find.text('domain5.com'), findsOneWidget);
      expect(find.text('domain6.com'), findsNothing);

      // Tap to expand
      await tester.tap(find.text('Sources'));
      await tester.pumpAndSettle();

      // After expansion, all domains should be visible
      expect(find.text('domain6.com'), findsOneWidget);
      expect(find.text('domain7.com'), findsOneWidget);

      // Tap to collapse
      await tester.tap(find.text('Sources'));
      await tester.pumpAndSettle();

      // After collapsing, only first 6 domains should be visible
      expect(find.text('domain0.com'), findsOneWidget);
      expect(find.text('domain5.com'), findsOneWidget);
      expect(find.text('domain6.com'), findsNothing);
    });

    testWidgets('opens source dialog when tapped', (tester) async {
      await mockNetworkImages(
        () async => tester.pumpApp(
          Material(child: Sources(articles: articles, domains: domains)),
        ),
      );

      // Tap on a domain
      await tester.tap(find.text('example.com'));
      await tester.pumpAndSettle();

      // Verify dialog appears
      expect(find.byType(SourceDialog), findsOneWidget);
      expect(
        find.text('example.com'),
        findsNWidgets(2),
      ); // One in list, one in dialog
      expect(find.text('Article 1'), findsOneWidget);
      expect(find.text('Article 2'), findsOneWidget);
    });
  });
}
