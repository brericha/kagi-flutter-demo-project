import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/widget/quote.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Quote', () {
    const quote = 'The best way to predict your future is to create it.';
    const quoteAuthor = 'Abraham Lincoln';
    const quoteSource = 'Goodreads';
    const quoteSourceUrl = 'https://www.goodreads.com/quotes/328848';

    testWidgets('renders quote correctly', (tester) async {
      await tester.pumpApp(
        const Quote(
          quote: quote,
          quoteAuthor: quoteAuthor,
          quoteSource: quoteSource,
          quoteSourceUrl: quoteSourceUrl,
        ),
      );

      expect(find.text(quote), findsOneWidget);
      expect(find.text('$quoteAuthor (via $quoteSource)'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('quote supports long text', (tester) async {
      const longQuote =
          'This is a very long quote that might span '
          'multiple lines when displayed on the screen. It is important to '
          'test how the widget handles longer text to ensure proper layout and '
          'readability for users viewing quotes of various lengths.';

      await tester.pumpApp(
        const Quote(
          quote: longQuote,
          quoteAuthor: quoteAuthor,
          quoteSource: quoteSource,
          quoteSourceUrl: quoteSourceUrl,
        ),
      );

      expect(find.text(longQuote), findsOneWidget);
      expect(find.text('$quoteAuthor (via $quoteSource)'), findsOneWidget);
    });
  });
}
