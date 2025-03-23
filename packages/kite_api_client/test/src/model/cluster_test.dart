// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:kite_api_client/src/model/article.dart';
import 'package:kite_api_client/src/model/cluster.dart';
import 'package:kite_api_client/src/model/domain.dart';
import 'package:kite_api_client/src/model/perspective.dart';
import 'package:test/test.dart';

void main() {
  group('Cluster', () {
    test('can be instantiated', () {
      expect(
        Cluster(
          number: 1,
          uniqueDomains: 5,
          numberOfTitles: 10,
          category: 'Test Category',
          title: 'Test Title',
          shortSummary: 'Test Summary',
          didYouKnow: 'Test Fact',
          talkingPoints: const ['Point 1', 'Point 2'],
          quote: 'Test Quote',
          quoteAuthor: 'Test Author',
          quoteSourceUrl: 'https://example.com',
          quoteSourceDomain: 'example.com',
          location: 'Test Location',
          emoji: '🧪',
          sections: const {
            'test_section': ['Item 1', 'Item 2'],
          },
          perspectives: const [
            Perspective('Test Perspective', [
              Source('Test Source', 'https://example.com'),
            ]),
          ],
          articles: const [
            Article(
              title: 'Test Article',
              link: 'https://example.com/article',
              domain: 'example.com',
            ),
          ],
          domains: const [
            Domain('example.com', 'https://example.com/favicon.ico'),
          ],
        ),
        isNotNull,
      );
    });

    test('supports value equality', () {
      final cluster1 = Cluster(
        number: 1,
        uniqueDomains: 5,
        numberOfTitles: 10,
        category: 'Test Category',
        title: 'Test Title',
        shortSummary: 'Test Summary',
        didYouKnow: 'Test Fact',
        talkingPoints: const ['Point 1', 'Point 2'],
        quote: 'Test Quote',
        quoteAuthor: 'Test Author',
        quoteSourceUrl: 'https://example.com',
        quoteSourceDomain: 'example.com',
        location: 'Test Location',
        emoji: '🧪',
        sections: const {
          'test_section': ['Item 1', 'Item 2'],
        },
        perspectives: const [
          Perspective('Test Perspective', [
            Source('Test Source', 'https://example.com'),
          ]),
        ],
        articles: const [
          Article(
            title: 'Test Article',
            link: 'https://example.com/article',
            domain: 'example.com',
          ),
        ],
        domains: const [
          Domain('example.com', 'https://example.com/favicon.ico'),
        ],
      );

      final cluster2 = Cluster(
        number: 1,
        uniqueDomains: 5,
        numberOfTitles: 10,
        category: 'Test Category',
        title: 'Test Title',
        shortSummary: 'Test Summary',
        didYouKnow: 'Test Fact',
        talkingPoints: const ['Point 1', 'Point 2'],
        quote: 'Test Quote',
        quoteAuthor: 'Test Author',
        quoteSourceUrl: 'https://example.com',
        quoteSourceDomain: 'example.com',
        location: 'Test Location',
        emoji: '🧪',
        sections: const {
          'test_section': ['Item 1', 'Item 2'],
        },
        perspectives: const [
          Perspective('Test Perspective', [
            Source('Test Source', 'https://example.com'),
          ]),
        ],
        articles: const [
          Article(
            title: 'Test Article',
            link: 'https://example.com/article',
            domain: 'example.com',
          ),
        ],
        domains: const [
          Domain('example.com', 'https://example.com/favicon.ico'),
        ],
      );

      expect(cluster1, equals(cluster2));

      final differentCluster = Cluster(
        number: 2, // Different number
        uniqueDomains: 5,
        numberOfTitles: 10,
        category: 'Test Category',
        title: 'Test Title',
        shortSummary: 'Test Summary',
        didYouKnow: 'Test Fact',
        talkingPoints: const ['Point 1', 'Point 2'],
        quote: 'Test Quote',
        quoteAuthor: 'Test Author',
        quoteSourceUrl: 'https://example.com',
        quoteSourceDomain: 'example.com',
        location: 'Test Location',
        emoji: '🧪',
        sections: const {
          'test_section': ['Item 1', 'Item 2'],
        },
        perspectives: const [
          Perspective('Test Perspective', [
            Source('Test Source', 'https://example.com'),
          ]),
        ],
        articles: const [
          Article(
            title: 'Test Article',
            link: 'https://example.com/article',
            domain: 'example.com',
          ),
        ],
        domains: const [
          Domain('example.com', 'https://example.com/favicon.ico'),
        ],
      );

      expect(cluster1, isNot(equals(differentCluster)));
    });

    group('fromJson', () {
      test('creates Cluster from valid JSON', () {
        final json = {
          'cluster_number': 1,
          'unique_domains': 5,
          'number_of_titles': 10,
          'category': 'Test Category',
          'title': 'Test Title',
          'short_summary': 'Test Summary',
          'did_you_know': 'Test Fact',
          'talking_points': ['Point 1', 'Point 2'],
          'quote': 'Test Quote',
          'quote_author': 'Test Author',
          'quote_source_url': 'https://example.com',
          'quote_source_domain': 'example.com',
          'location': 'Test Location',
          'emoji': '🧪',
          'scientific_significance': ['Significance 1', 'Significance 2'],
          'perspectives': [
            {
              'text': 'Test Perspective',
              'sources': [
                {
                  'name': 'Test Source',
                  'url': 'https://example.com',
                }
              ],
            }
          ],
          'articles': [
            {
              'title': 'Test Article',
              'link': 'https://example.com/article',
              'domain': 'example.com',
            }
          ],
          'domains': [
            {
              'name': 'example.com',
              'favicon': 'https://example.com/favicon.ico',
            }
          ],
        };

        final cluster = Cluster.fromJson(json);

        expect(cluster.number, equals(1));
        expect(cluster.uniqueDomains, equals(5));
        expect(cluster.numberOfTitles, equals(10));
        expect(cluster.category, equals('Test Category'));
        expect(cluster.title, equals('Test Title'));
        expect(cluster.shortSummary, equals('Test Summary'));
        expect(cluster.didYouKnow, equals('Test Fact'));
        expect(cluster.talkingPoints, equals(['Point 1', 'Point 2']));
        expect(cluster.quote, equals('Test Quote'));
        expect(cluster.quoteAuthor, equals('Test Author'));
        expect(cluster.quoteSourceUrl, equals('https://example.com'));
        expect(cluster.quoteSourceDomain, equals('example.com'));
        expect(cluster.location, equals('Test Location'));
        expect(cluster.emoji, equals('🧪'));

        // Check sections
        expect(cluster.sections.containsKey('scientific_significance'), isTrue);
        expect(
          cluster.sections['scientific_significance'],
          equals(['Significance 1', 'Significance 2']),
        );

        // Check perspectives
        expect(cluster.perspectives.length, equals(1));
        expect(cluster.perspectives.first.text, equals('Test Perspective'));
        expect(
          cluster.perspectives.first.sources.first.name,
          equals('Test Source'),
        );

        // Check articles
        expect(cluster.articles.length, equals(1));
        expect(cluster.articles.first.title, equals('Test Article'));

        // Check domains
        expect(cluster.domains.length, equals(1));
        expect(cluster.domains.first.name, equals('example.com'));
      });

      test('handles section data correctly', () {
        final json = {
          'cluster_number': 1,
          'unique_domains': 5,
          'number_of_titles': 10,
          'category': 'Test Category',
          'title': 'Test Title',
          'short_summary': 'Test Summary',
          'did_you_know': 'Test Fact',
          'talking_points': ['Point 1', 'Point 2'],
          'quote': 'Test Quote',
          'quote_author': 'Test Author',
          'quote_source_url': 'https://example.com',
          'quote_source_domain': 'example.com',
          'location': 'Test Location',
          'emoji': '🧪',
          'perspectives': <String>[],
          'articles': <String>[],
          'domains': <String>[],
          // Various section formats
          'scientific_significance': ['Item 1', 'Item 2'], // List format
          'historical_background': 'Single string value', // String format
          'timeline': <String>[], // Empty list
          'economic_implications': '', // Empty string
        };

        final cluster = Cluster.fromJson(json);

        // List format should be preserved
        expect(cluster.sections.containsKey('scientific_significance'), isTrue);
        expect(
          cluster.sections['scientific_significance'],
          equals(['Item 1', 'Item 2']),
        );

        // String format should be converted to a list with one item
        expect(cluster.sections.containsKey('historical_background'), isTrue);
        expect(
          cluster.sections['historical_background'],
          equals(['Single string value']),
        );

        // Empty formats should not be included
        expect(cluster.sections.containsKey('timeline'), isFalse);
        expect(cluster.sections.containsKey('economic_implications'), isFalse);
      });
    });

    test('can parse clusters from cluster.json', () async {
      final file = File('test/resource/cluster.json');
      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final clustersJson = json['clusters'] as List<dynamic>;

      final clusters = Cluster.listOf(clustersJson);

      // Basic checks to ensure we got data correctly
      expect(clusters, isNotEmpty);

      // Check first cluster
      final firstCluster = clusters.first;
      expect(
        firstCluster.title,
        equals('Ancient human face fossil discovered in Spain'),
      );
      expect(firstCluster.category, equals('Paleontology'));
      expect(firstCluster.emoji, equals('🧠'));
      expect(firstCluster.perspectives.length, equals(3));
      expect(firstCluster.articles.length, greaterThan(0));
      expect(firstCluster.domains.length, greaterThan(0));

      // Check specific sections
      expect(
        firstCluster.sections.containsKey('scientific_significance'),
        isTrue,
      );
      expect(firstCluster.sections.containsKey('timeline'), isTrue);

      // Verify nested objects were correctly parsed
      expect(
        firstCluster.perspectives.first.sources.first.name,
        equals('Nature'),
      );
      expect(firstCluster.articles.first.domain, equals('sciencealert.com'));
      expect(firstCluster.domains.first.name, equals('nature.com'));
    });

    test('listOf handles invalid items gracefully', () {
      const validItem = {
        'cluster_number': 1,
        'unique_domains': 5,
        'number_of_titles': 10,
        'category': 'Test Category',
        'title': 'Test Title',
        'short_summary': 'Test Summary',
        'did_you_know': 'Test Fact',
        'talking_points': ['Point 1', 'Point 2'],
        'quote': 'Test Quote',
        'quote_author': 'Test Author',
        'quote_source_url': 'https://example.com',
        'quote_source_domain': 'example.com',
        'location': 'Test Location',
        'emoji': '🧪',
        'perspectives': <String>[],
        'articles': <String>[],
        'domains': <String>[],
      };
      const invalidItem = 'Not a map';
      final list = [validItem, invalidItem];

      final clusters = Cluster.listOf(list);

      expect(clusters.length, equals(1));
      expect(clusters.first.title, equals('Test Title'));
    });
  });
}
