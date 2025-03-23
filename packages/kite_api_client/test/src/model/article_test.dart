// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:kite_api_client/src/model/article.dart';
import 'package:test/test.dart';

void main() {
  group('Article', () {
    test('can be instantiated', () {
      expect(
        Article(
          title: 'Test Article',
          link: 'https://example.com/article',
          domain: 'example.com',
        ),
        isNotNull,
      );
    });

    test('supports value equality', () {
      expect(
        Article(
          title: 'Test Article',
          link: 'https://example.com/article',
          domain: 'example.com',
        ),
        equals(
          Article(
            title: 'Test Article',
            link: 'https://example.com/article',
            domain: 'example.com',
          ),
        ),
      );

      expect(
        Article(
          title: 'Test Article',
          link: 'https://example.com/article',
          domain: 'example.com',
        ),
        isNot(
          equals(
            Article(
              title: 'Different Title',
              link: 'https://example.com/article',
              domain: 'example.com',
            ),
          ),
        ),
      );

      expect(
        Article(
          title: 'Test Article',
          link: 'https://example.com/article',
          domain: 'example.com',
          image: 'https://example.com/image.jpg',
          imageCaption: 'Test Caption',
        ),
        equals(
          Article(
            title: 'Test Article',
            link: 'https://example.com/article',
            domain: 'example.com',
            image: 'https://example.com/image.jpg',
            imageCaption: 'Test Caption',
          ),
        ),
      );
    });

    group('fromJson', () {
      test('creates Article from valid JSON with required fields only', () {
        final article = Article.fromJson(const {
          'title': 'Test Article',
          'link': 'https://example.com/article',
          'domain': 'example.com',
        });

        expect(article.title, equals('Test Article'));
        expect(article.link, equals('https://example.com/article'));
        expect(article.domain, equals('example.com'));
        expect(article.image, isNull);
        expect(article.imageCaption, isNull);
      });

      test('creates Article from valid JSON with all fields', () {
        final article = Article.fromJson(const {
          'title': 'Test Article',
          'link': 'https://example.com/article',
          'domain': 'example.com',
          'image': 'https://example.com/image.jpg',
          'image_caption': 'Test Caption',
        });

        expect(article.title, equals('Test Article'));
        expect(article.link, equals('https://example.com/article'));
        expect(article.domain, equals('example.com'));
        expect(article.image, equals('https://example.com/image.jpg'));
        expect(article.imageCaption, equals('Test Caption'));
      });

      test('throws when title is not a String', () {
        expect(
          () => Article.fromJson(const {
            'title': 123,
            'link': 'https://example.com/article',
            'domain': 'example.com',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when link is not a String', () {
        expect(
          () => Article.fromJson(const {
            'title': 'Test Article',
            'link': 123,
            'domain': 'example.com',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when domain is not a String', () {
        expect(
          () => Article.fromJson(const {
            'title': 'Test Article',
            'link': 'https://example.com/article',
            'domain': 123,
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    test('can parse articles from article.json using listOf method', () async {
      final file = File('test/resource/article.json');
      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString) as List<dynamic>;

      final articles = Article.listOf(json);

      expect(articles.length, equals(7));

      // Check first article with image and caption
      final firstArticle = articles.first;
      expect(
        firstArticle.title,
        equals('Plastic exposure may be making bacteria resistant to drugs'),
      );
      expect(
        firstArticle.link,
        equals(
          'https://www.futurity.org/microplastics-antibiotic-resistance-bacteria-3272712/',
        ),
      );
      expect(firstArticle.domain, equals('futurity.org'));
      expect(firstArticle.image, isNotNull);
      expect(
        firstArticle.imageCaption,
        equals(
          'Tiny plastic shards of different colors scattered on a '
          'light blue background.',
        ),
      );

      // Check an article with empty image and caption
      final lastArticle = articles.last;
      expect(lastArticle.title, contains('Bacteria exposed to microplastics'));
      expect(lastArticle.domain, equals('reddit.com'));
      expect(lastArticle.image, equals(''));
      expect(lastArticle.imageCaption, equals(''));
    });

    test('listOf handles invalid items gracefully', () {
      const validItem = {
        'title': 'Test Article',
        'link': 'https://example.com/article',
        'domain': 'example.com',
      };
      const invalidItem = 'Not a map';
      final list = [validItem, invalidItem];

      final articles = Article.listOf(list);

      expect(articles.length, equals(1));
      expect(articles.first.title, equals('Test Article'));
      expect(articles.first.link, equals('https://example.com/article'));
      expect(articles.first.domain, equals('example.com'));
    });
  });
}
