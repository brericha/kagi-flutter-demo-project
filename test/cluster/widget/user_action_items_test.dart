import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/widget/user_action_items.dart';

import '../../helpers/helpers.dart';

void main() {
  group('UserActionItems', () {
    testWidgets('renders action items with bullet points', (tester) async {
      const items = [
        'Sign up for emergency alerts',
        'Check evacuation routes',
        'Stock up on essential supplies',
      ];

      await tester.pumpApp(const UserActionItems(items));

      expect(find.text('Action items'), findsOneWidget);
      expect(
        find.text(
          '• Sign up for emergency alerts\n• Check '
          'evacuation routes\n• Stock up on essential supplies',
        ),
        findsOneWidget,
      );
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('renders correctly with single item', (tester) async {
      const items = ['Follow the situation on social media'];

      await tester.pumpApp(const UserActionItems(items));

      expect(find.text('Action items'), findsOneWidget);
      expect(
        find.text('• Follow the situation on social media'),
        findsOneWidget,
      );
    });

    testWidgets('handles empty list gracefully', (tester) async {
      const items = <String>[];

      await tester.pumpApp(const UserActionItems(items));

      expect(find.text('Action items'), findsOneWidget);
      expect(find.text(''), findsOneWidget); // Empty subtitle
    });
  });
}
