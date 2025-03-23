import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/cluster/widget/article_image.dart';
import 'package:kite_api_client/kite_api_client.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ArticleImage', () {
    const article = Article(
      title: 'Test Article',
      link: 'https://example.com/article',
      domain: 'example.com',
      image: 'https://example.com/image.jpg',
      imageCaption: 'Test Image Caption',
    );

    testWidgets('renders ArticleImage', (tester) async {
      await mockNetworkImages(
        () async => tester.pumpApp(const ArticleImage(article)),
      );

      expect(find.byType(ArticleImage), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('example.com'), findsOneWidget);
      expect(find.text('Test Image Caption'), findsOneWidget);
    });

    testWidgets('does not show image caption when null', (tester) async {
      const articleWithoutCaption = Article(
        title: 'Test Article',
        link: 'https://example.com/article',
        domain: 'example.com',
        image: 'https://example.com/image.jpg',
        imageCaption: null,
      );

      await mockNetworkImages(
        () async => tester.pumpApp(const ArticleImage(articleWithoutCaption)),
      );

      expect(find.byType(Padding).last, isNot(find.byType(Text)));
    });
  });
}
