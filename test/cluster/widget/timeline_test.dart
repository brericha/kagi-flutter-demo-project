import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/widget/timeline.dart';
import 'package:kite/cluster/data/timeline_event.dart';
import 'package:kite/widget/timeline_list.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Timeline', () {
    testWidgets('renders timeline with events', (tester) async {
      final events = [
        '2023-01-01:: First event description',
        '2023-01-15:: Second event description',
        '2023-02-01:: Third event description',
      ];

      await tester.pumpApp(Timeline(events));

      // Verify heading
      expect(find.text('Timeline of events'), findsOneWidget);

      // Verify events are rendered
      expect(find.text('2023-01-01'), findsOneWidget);
      expect(find.text('First event description'), findsOneWidget);
      expect(find.text('2023-01-15'), findsOneWidget);
      expect(find.text('Second event description'), findsOneWidget);
      expect(find.text('2023-02-01'), findsOneWidget);
      expect(find.text('Third event description'), findsOneWidget);

      // Verify numbered circles
      expect(find.widgetWithText(CircleAvatar, '1'), findsOneWidget);
      expect(find.widgetWithText(CircleAvatar, '2'), findsOneWidget);
      expect(find.widgetWithText(CircleAvatar, '3'), findsOneWidget);

      // Verify widget structure
      expect(find.byType(TimelineList), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('handles empty events list', (tester) async {
      await tester.pumpApp(const Timeline([]));

      expect(find.text('Timeline of events'), findsOneWidget);
      expect(find.byType(TimelineList), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNothing);
    });

    test(
      'TimelineEvent.fromString throws FormatException for malformed strings',
      () {
        expect(
          () => TimelineEvent.fromString(
            'Invalid event format without separator',
          ),
          throwsFormatException,
        );
      },
    );
  });
}
