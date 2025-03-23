import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:kite/news/data/wikipedia_client.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('WikipediaClient', () {
    late http.Client mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
    });

    group('fetchWikiImage', () {
      const wikipediaHtml =
          '<a href="https://en.wikipedia.org/wiki/Test_Article">Test</a>';
      const apiUrl =
          'https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=original&titles=Test_Article';
      const imageUrl = 'https://example.com/image.jpg';

      test('returns image URL when successful', () async {
        // Mock successful API response
        when(() => mockHttpClient.get(Uri.parse(apiUrl))).thenAnswer(
          (_) async => http.Response(
            '{"query":{"pages":{"12345":{"original":{"source":"$imageUrl"}}}}}',
            200,
          ),
        );

        final result = await WikipediaClient.fetchWikiImage(
          wikipediaHtml,
          httpClient: mockHttpClient,
        );

        verify(() => mockHttpClient.get(Uri.parse(apiUrl))).called(1);
        expect(result, equals(imageUrl));
      });

      test('returns null when image not found in response', () async {
        // Mock response with no image
        when(() => mockHttpClient.get(Uri.parse(apiUrl))).thenAnswer(
          (_) async => http.Response('{"query":{"pages":{"12345":{}}}}', 200),
        );

        final result = await WikipediaClient.fetchWikiImage(
          wikipediaHtml,
          httpClient: mockHttpClient,
        );

        verify(() => mockHttpClient.get(Uri.parse(apiUrl))).called(1);
        expect(result, isNull);
      });

      test('returns null when API request fails', () async {
        // Mock failed API response
        when(
          () => mockHttpClient.get(Uri.parse(apiUrl)),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final result = await WikipediaClient.fetchWikiImage(
          wikipediaHtml,
          httpClient: mockHttpClient,
        );

        verify(() => mockHttpClient.get(Uri.parse(apiUrl))).called(1);
        expect(result, isNull);
      });

      test('returns null when an exception occurs', () async {
        // Mock exception
        when(
          () => mockHttpClient.get(Uri.parse(apiUrl)),
        ).thenThrow(Exception('Network error'));

        final result = await WikipediaClient.fetchWikiImage(
          wikipediaHtml,
          httpClient: mockHttpClient,
        );

        verify(() => mockHttpClient.get(Uri.parse(apiUrl))).called(1);
        expect(result, isNull);
      });
    });

    group('_extractWikipediaTitle', () {
      test('returns null for non-Wikipedia URL', () async {
        const html = '<a href="https://example.com/page">Link</a>';

        final result = await WikipediaClient.fetchWikiImage(
          html,
          httpClient: mockHttpClient,
        );

        expect(result, isNull);
      });

      test('returns null for malformed Wikipedia URL', () async {
        const html =
            '<a href="https://en.wikipedia.org/not-wiki/page">Link</a>';

        final result = await WikipediaClient.fetchWikiImage(
          html,
          httpClient: mockHttpClient,
        );

        expect(result, isNull);
      });

      test('throws exception when no links are found', () async {
        const html = 'Text with no links';

        final result = await WikipediaClient.fetchWikiImage(
          html,
          httpClient: mockHttpClient,
        );

        expect(result, isNull);
      });
    });
  });
}
