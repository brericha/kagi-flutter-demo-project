import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/widget/perspectives.dart';
import 'package:kite_api_client/kite_api_client.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Perspectives', () {
    const perspectives = [
      Perspective('Liberal View: This policy will help reduce inequality', [
        Source('The Guardian', 'https://theguardian.com'),
      ]),
      Perspective('Conservative View: This policy will harm economic growth', [
        Source('Wall Street Journal', 'https://wsj.com'),
      ]),
    ];

    testWidgets('renders perspectives correctly', (tester) async {
      await tester.pumpApp(const Perspectives(perspectives));

      expect(find.text('Perspectives'), findsOneWidget);
      expect(find.text('Liberal View'), findsOneWidget);
      expect(
        find.text('This policy will help reduce inequality'),
        findsOneWidget,
      );
      expect(find.text('The Guardian'), findsOneWidget);
      expect(find.text('Conservative View'), findsOneWidget);
      expect(
        find.text('This policy will harm economic growth'),
        findsOneWidget,
      );
      expect(find.text('Wall Street Journal'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.byType(TextButton), findsNWidgets(2));
    });

    testWidgets('renders empty state when no perspectives are provided', (
      tester,
    ) async {
      await tester.pumpApp(const Perspectives([]));

      expect(find.text('Perspectives'), findsOneWidget);
      expect(find.byType(Card), findsNothing);
      expect(find.byType(TextButton), findsNothing);
    });
  });
}
