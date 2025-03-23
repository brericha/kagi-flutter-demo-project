// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:kite_api_client/src/model/category_response.dart';
import 'package:test/test.dart';

void main() {
  group('CategoryResponse', () {
    test('can be instantiated', () {
      expect(
        CategoryResponse(
          category: 'Test Category',
          timestamp: 1234567890,
          read: 100,
          clusters: const [],
        ),
        isNotNull,
      );
    });

    test('supports value equality', () {
      final response1 = CategoryResponse(
        category: 'Test Category',
        timestamp: 1234567890,
        read: 100,
        clusters: const [],
      );

      final response2 = CategoryResponse(
        category: 'Test Category',
        timestamp: 1234567890,
        read: 100,
        clusters: const [],
      );

      expect(response1, equals(response2));

      final differentResponse = CategoryResponse(
        category: 'Different Category',
        timestamp: 1234567890,
        read: 100,
        clusters: const [],
      );

      expect(response1, isNot(equals(differentResponse)));
    });

    group('fromJson', () {
      test('creates CategoryResponse from valid JSON', () {
        final json = {
          'category': 'Test Category',
          'timestamp': 1234567890,
          'read': 100,
          'clusters': <dynamic>[],
        };

        final response = CategoryResponse.fromJson(json);

        expect(response.category, equals('Test Category'));
        expect(response.timestamp, equals(1234567890));
        expect(response.read, equals(100));
        expect(response.clusters, isEmpty);
      });

      test('creates CategoryResponse with clusters from valid JSON', () {
        final json = {
          'category': 'Test Category',
          'timestamp': 1234567890,
          'read': 100,
          'clusters': [
            {
              'cluster_number': 1,
              'unique_domains': 5,
              'number_of_titles': 10,
              'category': 'Test Cluster Category',
              'title': 'Test Cluster Title',
              'short_summary': 'Test Summary',
              'did_you_know': 'Test Fact',
              'talking_points': <String>['Point 1', 'Point 2'],
              'quote': 'Test Quote',
              'quote_author': 'Test Author',
              'quote_source_url': 'https://example.com',
              'quote_source_domain': 'example.com',
              'location': 'Test Location',
              'emoji': '🧪',
              'scientific_significance': <String>['Item 1', 'Item 2'],
              'perspectives': <dynamic>[],
              'articles': <dynamic>[],
              'domains': <dynamic>[],
            }
          ],
        };

        final response = CategoryResponse.fromJson(json);

        expect(response.category, equals('Test Category'));
        expect(response.timestamp, equals(1234567890));
        expect(response.read, equals(100));
        expect(response.clusters, isNotEmpty);
        expect(response.clusters.length, equals(1));
        expect(response.clusters.first.title, equals('Test Cluster Title'));
      });

      test('throws when category is not a String', () {
        final json = {
          'category': 123,
          'timestamp': 1234567890,
          'read': 100,
          'clusters': <dynamic>[],
        };

        expect(
          () => CategoryResponse.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when timestamp is not an int', () {
        final json = {
          'category': 'Test Category',
          'timestamp': 'not an int',
          'read': 100,
          'clusters': <dynamic>[],
        };

        expect(
          () => CategoryResponse.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when read is not an int', () {
        final json = {
          'category': 'Test Category',
          'timestamp': 1234567890,
          'read': 'not an int',
          'clusters': <dynamic>[],
        };

        expect(
          () => CategoryResponse.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when clusters is not a List', () {
        final json = {
          'category': 'Test Category',
          'timestamp': 1234567890,
          'read': 100,
          'clusters': 'not a list',
        };

        expect(
          () => CategoryResponse.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });
    });

    test('can parse category response from cluster.json', () async {
      final file = File('test/resource/cluster.json');
      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      final response = CategoryResponse.fromJson(json);

      // Check properties
      expect(response.category, equals('Science'));
      expect(response.timestamp, isA<int>());
      expect(response.read, isA<int>());
      expect(response.clusters, isNotEmpty);

      // Check clusters
      final firstCluster = response.clusters.first;
      expect(
        firstCluster.title,
        equals('Ancient human face fossil discovered in Spain'),
      );
      expect(firstCluster.category, equals('Paleontology'));
      expect(firstCluster.emoji, equals('🧠'));

      // Verify nested objects were correctly parsed
      expect(firstCluster.perspectives.isNotEmpty, isTrue);
      expect(firstCluster.articles.isNotEmpty, isTrue);
      expect(firstCluster.domains.isNotEmpty, isTrue);

      // Check a specific domain to verify deep parsing
      final domainNames = firstCluster.domains.map((d) => d.name).toList();
      expect(domainNames, contains('nature.com'));
    });
  });
}
