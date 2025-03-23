// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:kite_api_client/src/model/domain.dart';
import 'package:test/test.dart';

void main() {
  group('Domain', () {
    test('can be instantiated', () {
      expect(
        Domain('example.com', 'https://example.com/favicon.ico'),
        isNotNull,
      );
    });

    test('supports value equality', () {
      expect(
        Domain('example.com', 'https://example.com/favicon.ico'),
        equals(Domain('example.com', 'https://example.com/favicon.ico')),
      );
      expect(
        Domain('example.com', 'https://example.com/favicon.ico'),
        isNot(
          equals(Domain('different.com', 'https://example.com/favicon.ico')),
        ),
      );
      expect(
        Domain('example.com', 'https://example.com/favicon.ico'),
        isNot(
          equals(Domain('example.com', 'https://example.com/different.ico')),
        ),
      );
    });

    group('fromJson', () {
      test('creates Domain from valid JSON', () {
        final domain = Domain.fromJson(const {
          'name': 'example.com',
          'favicon': 'https://example.com/favicon.ico',
        });

        expect(domain.name, equals('example.com'));
        expect(domain.favicon, equals('https://example.com/favicon.ico'));
      });

      test('throws when name is not a String', () {
        expect(
          () => Domain.fromJson(const {
            'name': 123,
            'favicon': 'https://example.com/favicon.ico',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when favicon is not a String', () {
        expect(
          () => Domain.fromJson(const {
            'name': 'example.com',
            'favicon': 123,
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    test('can parse domains from domain.json using listOf method', () async {
      final file = File('test/resource/domain.json');
      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString) as List<dynamic>;

      final domains = Domain.listOf(json);

      expect(domains.length, equals(5));

      // Check first domain
      expect(domains.first.name, equals('discovermagazine.com'));
      expect(domains.first.favicon, startsWith('https://kagiproxy.com/img/'));

      // Check a domain in the middle
      final futurityDomain =
          domains.firstWhere((d) => d.name == 'futurity.org');
      expect(futurityDomain.favicon, startsWith('https://kagiproxy.com/img/'));

      // Check last domain
      expect(domains.last.name, equals('technologynetworks.com'));
      expect(domains.last.favicon, startsWith('https://kagiproxy.com/img/'));
    });

    test('listOf handles invalid items gracefully', () {
      const validItem = {
        'name': 'example.com',
        'favicon': 'https://example.com/favicon.ico',
      };
      const invalidItem = 'Not a map';
      final list = [validItem, invalidItem];

      final domains = Domain.listOf(list);

      expect(domains.length, equals(1));
      expect(domains.first.name, equals('example.com'));
      expect(domains.first.favicon, equals('https://example.com/favicon.ico'));
    });
  });
}
