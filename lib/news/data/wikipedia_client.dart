import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class WikipediaClient {
  static Future<String?> fetchWikiImage(
    String content, {
    http.Client? httpClient,
  }) async {
    final http.Client client;
    if (httpClient != null) {
      client = httpClient;
    } else {
      client = http.Client();
    }

    const baseUrl =
        'https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=original&titles=';

    try {
      final title = _extractWikipediaTitle(content);
      final apiUrl = Uri.encodeFull(baseUrl + title);

      final response = await client.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        final pages =
            (data['query'] as Map<String, dynamic>)['pages']
                as Map<String, dynamic>;
        final pageId = pages.keys.first;

        if (pages[pageId]['original'] != null &&
            pages[pageId]['original']['source'] != null) {
          return pages[pageId]['original']['source'] as String;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  static String _extractWikipediaTitle(String content) {
    final url = _extractFirstHref(content);
    if (url != null) {
      final uri = Uri.parse(url);

      if (!uri.host.contains('wikipedia.org')) {
        throw ArgumentError('Not a valid wikipedia URL');
      }

      final path = uri.path;
      final segments = path.split('/');

      // In most Wikipedia URLs the title is the last segment after /wiki/
      if (segments.length >= 2 && segments[1] == 'wiki') {
        return Uri.decodeComponent(segments.last);
      } else {
        throw ArgumentError(
          'URL does not contain a valid Wikipedia article path',
        );
      }
    } else {
      throw ArgumentError('No links within content');
    }
  }

  static String? _extractFirstHref(String html) {
    // Regular expression to match the href attribute in the first <a> tag
    // This pattern looks for href="..." within an <a> tag
    final regExp = RegExp(
      r'<a\s+(?:[^>]*?\s+)?href="([^"]*)"',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(html);
    return match?.group(1);
  }
}
