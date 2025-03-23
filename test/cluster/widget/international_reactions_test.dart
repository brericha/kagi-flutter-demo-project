import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/widget/international_reactions.dart';

import '../../helpers/helpers.dart';

void main() {
  group('InternationalReactions', () {
    testWidgets('renders InternationalReactions with data', (tester) async {
      const reactions = <String>[
        'United States: Expressed deep concern over the recent developments',
        'European Union: Called for immediate de-escalation and dialogue',
      ];

      await tester.pumpApp(const InternationalReactions(reactions));

      expect(find.text('International reactions'), findsOneWidget);
      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Expressed deep concern over the recent developments'), findsOneWidget);
      expect(find.text('European Union'), findsOneWidget);
      expect(find.text('Called for immediate de-escalation and dialogue'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('renders empty list when no data is provided', (tester) async {
      const reactions = <String>[];

      await tester.pumpApp(const InternationalReactions(reactions));

      expect(find.text('International reactions'), findsOneWidget);
      expect(find.byType(Card), findsNothing);
    });
  });
}