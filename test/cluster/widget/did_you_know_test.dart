import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/widget/did_you_know.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DidYouKnow', () {
    testWidgets('renders DidYouKnow', (tester) async {
      const message = 'Something interesting';

      await tester.pumpApp(const DidYouKnow(message));

      expect(find.text(message), findsOneWidget);
    });
  });
}
