// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:kite_api_client/src/model/category.dart';
import 'package:test/test.dart';

void main() {
  group('Category', () {
    test('can be instantiated', () {
      expect(
        Category('World', 'world.json'),
        isNotNull,
      );
    });

    test('supports value equality', () {
      expect(
        Category('World', 'world.json'),
        equals(Category('World', 'world.json')),
      );
      expect(
        Category('World', 'world.json'),
        isNot(equals(Category('USA', 'world.json'))),
      );
      expect(
        Category('World', 'world.json'),
        isNot(equals(Category('World', 'usa.json'))),
      );
    });

    group('fromJson', () {
      test('creates Category from valid JSON', () {
        final category = Category.fromJson(const {
          'name': 'World',
          'file': 'world.json',
        });

        expect(category.name, equals('World'));
        expect(category.file, equals('world.json'));
      });

      test('throws when name is not a String', () {
        expect(
          () => Category.fromJson(const {
            'name': 123,
            'file': 'world.json',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when file is not a String', () {
        expect(
          () => Category.fromJson(const {
            'name': 'World',
            'file': 123,
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    test('can parse categories from kite.json using listOf method', () async {
      final file = File('test/resource/kite.json');
      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final categoriesJson = json['categories'] as List<dynamic>;

      final categories = Category.listOf(categoriesJson);

      expect(categories.length, equals(37));

      // Check first category
      expect(categories.first.name, equals('World'));
      expect(categories.first.file, equals('world.json'));

      // Check a category in the middle
      final techCategory = categories.firstWhere((c) => c.name == 'Technology');
      expect(techCategory.file, equals('tech.json'));

      // Check last category
      expect(categories.last.name, equals('OnThisDay'));
      expect(categories.last.file, equals('onthisday.json'));
    });

    test('listOf handles invalid items gracefully', () {
      const validItem = {'name': 'Test', 'file': 'test.json'};
      const invalidItem = 'Not a map';
      final list = [validItem, invalidItem];

      final categories = Category.listOf(list);

      expect(categories.length, equals(1));
      expect(categories.first.name, equals('Test'));
      expect(categories.first.file, equals('test.json'));
    });
  });
}
