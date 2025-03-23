import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/widget/location.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Location', () {
    testWidgets('renders Location', (tester) async {
      const locationName = 'Washington D.C';

      await tester.pumpApp(const Location(locationName));

      expect(find.text(locationName), findsOneWidget);
    });
  });
}
