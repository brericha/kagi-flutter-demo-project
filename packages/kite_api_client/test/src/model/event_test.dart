// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:kite_api_client/src/model/event.dart';
import 'package:test/test.dart';

void main() {
  group('Event', () {
    test('can be instantiated', () {
      expect(
        Event(
          year: '2023',
          sortYear: 2023,
          content: 'Test event content',
          type: 'event',
        ),
        isNotNull,
      );
    });

    group('fromJson', () {
      test('creates Event from valid JSON', () {
        final event = Event.fromJson(const {
          'year': '2015',
          'content': 'Test content',
          'sort_year': 2015.2,
          'type': 'people',
        });

        expect(event.year, equals('2015'));
        expect(event.content, equals('Test content'));
        expect(event.sortYear, equals(2015.2));
        expect(event.type, equals('people'));
      });

      test('throws when year is not a String', () {
        expect(
          () => Event.fromJson(const {
            'year': 2015,
            'content': 'Test content',
            'sort_year': 2015.2,
            'type': 'people',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when content is not a String', () {
        expect(
          () => Event.fromJson(const {
            'year': '2015',
            'content': 123,
            'sort_year': 2015.2,
            'type': 'people',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when sort_year is not a double', () {
        expect(
          () => Event.fromJson(const {
            'year': '2015',
            'content': 'Test content',
            'sort_year': '2015.2',
            'type': 'people',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when type is not a String', () {
        expect(
          () => Event.fromJson(const {
            'year': '2015',
            'content': 'Test content',
            'sort_year': 2015.2,
            'type': 123,
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('listOf', () {
      test('creates list of Events from valid JSON list', () {
        final list = [
          const {
            'year': '2015',
            'content': 'Event 1',
            'sort_year': 2015.2,
            'type': 'people',
          },
          const {
            'year': '2023',
            'content': 'Event 2',
            'sort_year': 2023.0,
            'type': 'event',
          },
        ];

        final events = Event.listOf(list);

        expect(events.length, equals(2));
        expect(events[0].year, equals('2015'));
        expect(events[0].content, equals('Event 1'));
        expect(events[0].sortYear, equals(2015.2));
        expect(events[0].type, equals('people'));

        expect(events[1].year, equals('2023'));
        expect(events[1].content, equals('Event 2'));
        expect(events[1].sortYear, equals(2023.0));
        expect(events[1].type, equals('event'));
      });

      test('handles invalid items gracefully', () {
        const validItem = {
          'year': '2015',
          'content': 'Valid item',
          'sort_year': 2015.2,
          'type': 'people',
        };
        const invalidItem = 'Not a map';
        final list = [validItem, invalidItem];

        final events = Event.listOf(list);

        expect(events.length, equals(1));
        expect(events[0].year, equals('2015'));
        expect(events[0].content, equals('Valid item'));
      });
    });

    test('can parse events from onthisday.json', () async {
      final file = File('test/resource/onthisday.json');
      final jsonString = await file.readAsString();
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final eventsJson = jsonMap['events'] as List<dynamic>;

      final events = Event.listOf(eventsJson);

      expect(events.length, equals(18));

      // Check first event
      expect(events.first.year, equals('2015'));
      expect(events.first.sortYear, equals(2015.2));
      expect(events.first.type, equals('people'));
      expect(
        events.first.content,
        contains('Terry Pratchett'),
      );

      // Check event in the middle
      final truman = events.firstWhere(
        (e) => e.content.contains('Truman Doctrine'),
      );
      expect(truman.year, equals('1947'));
      expect(truman.sortYear, equals(1947.0));
      expect(truman.type, equals('event'));

      // Check last event
      expect(events.last.year, equals('604'));
      expect(events.last.sortYear, equals(604.2));
      expect(events.last.type, equals('people'));
      expect(events.last.content, contains('Gregory I'));
    });
  });
}
