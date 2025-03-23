// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:kite_api_client/src/model/perspective.dart';
import 'package:test/test.dart';

void main() {
  group('Source', () {
    test('can be instantiated', () {
      expect(
        Source('Test Source', 'https://example.com'),
        isNotNull,
      );
    });

    test('supports value equality', () {
      expect(
        Source('Test Source', 'https://example.com'),
        equals(Source('Test Source', 'https://example.com')),
      );
      expect(
        Source('Test Source', 'https://example.com'),
        isNot(equals(Source('Different Source', 'https://example.com'))),
      );
      expect(
        Source('Test Source', 'https://example.com'),
        isNot(equals(Source('Test Source', 'https://different.com'))),
      );
    });

    group('fromJson', () {
      test('creates Source from valid JSON', () {
        final source = Source.fromJson(const {
          'name': 'Test Source',
          'url': 'https://example.com',
        });

        expect(source.name, equals('Test Source'));
        expect(source.url, equals('https://example.com'));
      });

      test('throws when name is not a String', () {
        expect(
          () => Source.fromJson(const {
            'name': 123,
            'url': 'https://example.com',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when url is not a String', () {
        expect(
          () => Source.fromJson(const {
            'name': 'Test Source',
            'url': 123,
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    test('listOf creates sources from valid JSON list', () {
      final sourcesList = Source.listOf([
        {
          'name': 'Source 1',
          'url': 'https://example1.com',
        },
        {
          'name': 'Source 2',
          'url': 'https://example2.com',
        },
      ]);

      expect(sourcesList.length, equals(2));
      expect(sourcesList[0].name, equals('Source 1'));
      expect(sourcesList[0].url, equals('https://example1.com'));
      expect(sourcesList[1].name, equals('Source 2'));
      expect(sourcesList[1].url, equals('https://example2.com'));
    });

    test('listOf handles invalid items gracefully', () {
      const validItem = {
        'name': 'Test Source',
        'url': 'https://example.com',
      };
      const invalidItem = 'Not a map';
      final list = [validItem, invalidItem];

      final sources = Source.listOf(list);

      expect(sources.length, equals(1));
      expect(sources.first.name, equals('Test Source'));
      expect(sources.first.url, equals('https://example.com'));
    });
  });

  group('Perspective', () {
    test('can be instantiated', () {
      expect(
        Perspective(
          'Test perspective text',
          const [Source('Test Source', 'https://example.com')],
        ),
        isNotNull,
      );
    });

    test('supports value equality', () {
      final source1 = Source('Test Source', 'https://example.com');
      final source2 = Source('Another Source', 'https://another.com');

      expect(
        Perspective('Test perspective', [source1]),
        equals(Perspective('Test perspective', [source1])),
      );
      expect(
        Perspective('Test perspective', [source1]),
        isNot(equals(Perspective('Different perspective', [source1]))),
      );
      expect(
        Perspective('Test perspective', [source1]),
        isNot(equals(Perspective('Test perspective', [source2]))),
      );
      expect(
        Perspective('Test perspective', [source1, source2]),
        equals(Perspective('Test perspective', [source1, source2])),
      );
    });

    group('fromJson', () {
      test('creates Perspective from valid JSON', () {
        final perspective = Perspective.fromJson(const {
          'text': 'Test perspective text',
          'sources': [
            {
              'name': 'Test Source',
              'url': 'https://example.com',
            },
          ],
        });

        expect(perspective.text, equals('Test perspective text'));
        expect(perspective.sources.length, equals(1));
        expect(perspective.sources.first.name, equals('Test Source'));
        expect(perspective.sources.first.url, equals('https://example.com'));
      });

      test('throws when text is not a String', () {
        expect(
          () => Perspective.fromJson(const {
            'text': 123,
            'sources': [
              {
                'name': 'Test Source',
                'url': 'https://example.com',
              },
            ],
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when sources is not a List', () {
        expect(
          () => Perspective.fromJson(const {
            'text': 'Test perspective text',
            'sources': 'Not a list',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    test('can parse perspectives from perspective.json using listOf method',
        () async {
      final file = File('test/resource/perspective.json');
      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString) as List<dynamic>;

      final perspectives = Perspective.listOf(json);

      expect(perspectives.length, equals(2));

      // Check first perspective
      expect(
        perspectives.first.text,
        contains(
          'Medical researchers: Intravenous infusion bags release '
          'microplastics',
        ),
      );
      expect(perspectives.first.sources.length, equals(1));
      expect(
        perspectives.first.sources.first.name,
        equals('Technology Networks'),
      );
      expect(
        perspectives.first.sources.first.url,
        equals(
          'https://www.technologynetworks.com/applied-sciences/news/medical-infusion-bags-can-release-microplastics-study-shows-397119',
        ),
      );

      // Check second perspective
      expect(
        perspectives.last.text,
        contains(
          'Public health scientists: The microplastic-antibiotic '
          'resistance connection',
        ),
      );
      expect(perspectives.last.sources.length, equals(1));
      expect(perspectives.last.sources.first.name, equals('Science Daily'));
      expect(
        perspectives.last.sources.first.url,
        equals(
          'https://www.sciencedaily.com/releases/2025/03/250311121511.htm',
        ),
      );
    });

    test('listOf handles invalid items gracefully', () {
      const validItem = {
        'text': 'Test perspective text',
        'sources': [
          {
            'name': 'Test Source',
            'url': 'https://example.com',
          },
        ],
      };
      const invalidItem = 'Not a map';
      final list = [validItem, invalidItem];

      final perspectives = Perspective.listOf(list);

      expect(perspectives.length, equals(1));
      expect(perspectives.first.text, equals('Test perspective text'));
      expect(perspectives.first.sources.length, equals(1));
      expect(perspectives.first.sources.first.name, equals('Test Source'));
    });
  });
}
