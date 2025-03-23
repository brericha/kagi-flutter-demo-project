import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/widget/section.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Section', () {
    testWidgets('renders section with known title - geopolitical_context', (
      tester,
    ) async {
      const data = [
        'The conflict has regional implications',
        'Multiple countries are involved',
      ];

      await tester.pumpApp(
        const Section(name: 'geopolitical_context', data: data),
      );

      expect(find.text('Geopolitical context'), findsOneWidget);
      expect(
        find.text('• The conflict has regional implications'),
        findsOneWidget,
      );
      expect(find.text('• Multiple countries are involved'), findsOneWidget);
    });

    testWidgets('renders section with single paragraph text', (tester) async {
      const data = [
        'This is a detailed historical account of the events that led to the current situation.',
      ];

      await tester.pumpApp(
        const Section(name: 'historical_background', data: data),
      );

      expect(find.text('Historical background'), findsOneWidget);
      expect(
        find.text(
          'This is a detailed historical account of the events that led to the current situation.',
        ),
        findsOneWidget,
      );
      expect(
        find.byType(ListView),
        findsNothing,
      ); // Single paragraph should not use ListView
    });

    testWidgets(
      'renders section with unknown name using sentence case formatting',
      (tester) async {
        const data = ['Point 1', 'Point 2', 'Point 3'];

        await tester.pumpApp(
          const Section(name: 'custom_section_name', data: data),
        );

        expect(find.text('Custom section name'), findsOneWidget);
        expect(find.text('• Point 1'), findsOneWidget);
        expect(find.text('• Point 2'), findsOneWidget);
        expect(find.text('• Point 3'), findsOneWidget);
      },
    );

    testWidgets('renders multiple points using ListView with bullet points', (
      tester,
    ) async {
      const data = ['First impact', 'Second impact', 'Third impact'];

      await tester.pumpApp(
        const Section(name: 'humanitarian_impact', data: data),
      );

      expect(find.text('Humanitarian impact'), findsOneWidget);
      expect(find.text('• First impact'), findsOneWidget);
      expect(find.text('• Second impact'), findsOneWidget);
      expect(find.text('• Third impact'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
