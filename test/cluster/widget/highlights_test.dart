import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/widget/highlights.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Highlights', () {
    testWidgets('renders Highlights', (tester) async {
      const highlights = <String>[
        'Title 1: Description 1',
        'Title 2: Description 2',
      ];

      await tester.pumpApp(const Highlights(highlights));

      expect(find.text('Title 1'), findsOneWidget);
      expect(find.text('Description 1'), findsOneWidget);
      expect(find.text('Title 2'), findsOneWidget);
      expect(find.text('Description 2'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNWidgets(2));
    });

    testWidgets('renders Highlights with no header', (tester) async {
      const highlights = <String>['Description 1'];

      await tester.pumpApp(const Highlights(highlights));

      expect(find.text('Title 1'), findsNothing);
      expect(find.text('Description 1'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });
}
