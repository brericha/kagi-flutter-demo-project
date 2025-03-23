// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kite_api_client/src/kite_api_client.dart';
import 'package:kite_api_client/src/kite_api_exception.dart';
import 'package:kite_api_client/src/model/model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('KiteApiClient', () {
    late MockHttpClient httpClient;
    late KiteApiClient kiteApiClient;

    setUp(() {
      httpClient = MockHttpClient();
      kiteApiClient = KiteApiClient(httpClient: httpClient);
    });

    group('getCategories', () {
      test('makes correct http request', () async {
        // Set up mock response using kite.json test data
        final file = File('test/resource/kite.json');
        final jsonString = await file.readAsString();

        when(() => httpClient.get(Uri.parse('https://kite.kagi.com/kite.json')))
            .thenAnswer(
          (_) async => http.Response(
            jsonString,
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        // Call method under test
        final result = await kiteApiClient.getCategories();

        // Verify http request was made
        verify(
          () => httpClient.get(Uri.parse('https://kite.kagi.com/kite.json')),
        ).called(1);

        // Verify returned data matches expected
        final expectedJson = jsonDecode(jsonString) as Map<String, dynamic>;
        final expectedCategories =
            Category.listOf(expectedJson['categories'] as List<dynamic>)
              ..removeWhere((e) => e.name == 'OnThisDay');

        expect(result, equals(expectedCategories));
        expect(result.length, equals(expectedCategories.length));
        expect(result[0].name, equals('World'));
        expect(result[0].file, equals('world.json'));
      });

      test('throws KiteApiException on non-200 response', () async {
        when(() => httpClient.get(Uri.parse('https://kite.kagi.com/kite.json')))
            .thenAnswer((_) async => http.Response('Not found', 404));

        await expectLater(
          () => kiteApiClient.getCategories(),
          throwsA(
            isA<KiteApiException>().having(
              (e) => e.message,
              'message',
              'Invalid response code: 404',
            ),
          ),
        );
      });
    });

    group('getCategory', () {
      test('makes correct http request', () async {
        // Set up mock response using cluster.json test data
        final file = File('test/resource/cluster.json');
        final jsonString = await file.readAsString();

        // Test with a sample category file
        const categoryFile = 'science.json';

        when(
          () =>
              httpClient.get(Uri.parse('https://kite.kagi.com/$categoryFile')),
        ).thenAnswer(
          (_) async => http.Response(
            jsonString,
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        // Call method under test
        final result = await kiteApiClient.getCategory(categoryFile);

        // Verify http request was made
        verify(
          () =>
              httpClient.get(Uri.parse('https://kite.kagi.com/$categoryFile')),
        ).called(1);

        // Verify the returned result is a CategoryResponse
        expect(result, isA<CategoryResponse>());

        // Parse the expected data manually to verify
        final expectedJson = jsonDecode(jsonString) as Map<String, dynamic>;
        final expectedResponse = CategoryResponse.fromJson(expectedJson);

        expect(result, equals(expectedResponse));
        expect(result.category, equals(expectedResponse.category));
        expect(
          result.clusters.length,
          equals(expectedResponse.clusters.length),
        );
      });

      test('throws KiteApiException on non-200 response', () async {
        const categoryFile = 'tech.json';

        when(
          () =>
              httpClient.get(Uri.parse('https://kite.kagi.com/$categoryFile')),
        ).thenAnswer((_) async => http.Response('Not found', 404));

        await expectLater(
          () => kiteApiClient.getCategory(categoryFile),
          throwsA(
            isA<KiteApiException>().having(
              (e) => e.message,
              'message',
              'Invalid response code: 404',
            ),
          ),
        );
      });
    });

    group('getEvents', () {
      test('makes correct http request', () async {
        // Set up mock response using onthisday.json test data
        final file = File('test/resource/onthisday.json');
        final jsonString = await file.readAsString();

        when(
          () =>
              httpClient.get(Uri.parse('https://kite.kagi.com/onthisday.json')),
        ).thenAnswer(
          (_) async => http.Response(
            jsonString,
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        // Call method under test
        final result = await kiteApiClient.getEvents();

        // Verify http request was made
        verify(
          () =>
              httpClient.get(Uri.parse('https://kite.kagi.com/onthisday.json')),
        ).called(1);

        // Verify returned data matches expected
        final expectedJson = jsonDecode(jsonString) as Map<String, dynamic>;
        final expectedEvents =
            Event.listOf(expectedJson['events'] as List<dynamic>);

        expect(result, equals(expectedEvents));
        expect(result.length, equals(expectedEvents.length));

        if (result.isNotEmpty) {
          expect(result[0].year, equals(expectedEvents[0].year));
          expect(result[0].sortYear, equals(expectedEvents[0].sortYear));
          expect(result[0].content, equals(expectedEvents[0].content));
          expect(result[0].type, equals(expectedEvents[0].type));
        }
      });

      test('throws KiteApiException on non-200 response', () async {
        when(
          () =>
              httpClient.get(Uri.parse('https://kite.kagi.com/onthisday.json')),
        ).thenAnswer((_) async => http.Response('Not found', 404));

        await expectLater(
          () => kiteApiClient.getEvents(),
          throwsA(
            isA<KiteApiException>().having(
              (e) => e.message,
              'message',
              'Invalid response code: 404',
            ),
          ),
        );
      });

      test('returns empty list on invalid JSON', () async {
        when(
          () =>
              httpClient.get(Uri.parse('https://kite.kagi.com/onthisday.json')),
        ).thenAnswer(
          (_) async => http.Response(
            '{invalid json]',
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        final result = await kiteApiClient.getEvents();

        verify(
          () =>
              httpClient.get(Uri.parse('https://kite.kagi.com/onthisday.json')),
        ).called(1);

        expect(result, isA<List<Event>>());
        expect(result, isEmpty);
      });

      test('handles empty events array', () async {
        // Test with valid JSON but empty events array
        const emptyEventsJson = '{"events":[]}';

        when(
          () =>
              httpClient.get(Uri.parse('https://kite.kagi.com/onthisday.json')),
        ).thenAnswer(
          (_) async => http.Response(
            emptyEventsJson,
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        final result = await kiteApiClient.getEvents();

        expect(result, isA<List<Event>>());
        expect(result, isEmpty);
      });

      test('handles invalid items in events array', () async {
        // Test JSON with some invalid entries in the events array
        const mixedEventsJson = '''
        {
          "events": [
            {
              "year": "2023",
              "sort_year": 2023,
              "content": "Valid event",
              "type": "event"
            },
            "This is not a valid event object",
            {
              "missing_required_fields": true
            }
          ]
        }
        ''';

        when(
          () =>
              httpClient.get(Uri.parse('https://kite.kagi.com/onthisday.json')),
        ).thenAnswer(
          (_) async => http.Response(
            mixedEventsJson,
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        // Should only return the valid event and log errors for the others
        final result = await kiteApiClient.getEvents();

        expect(result, isA<List<Event>>());
        expect(result.length, equals(1));
        expect(result[0].year, equals('2023'));
        expect(result[0].content, equals('Valid event'));
      });
    });
  });
}
