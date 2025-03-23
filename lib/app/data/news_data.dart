import 'package:kite_api_client/kite_api_client.dart';

/// Data class to hold the various responses from the API.
class NewsData {
  const NewsData({
    required this.categories,
    required this.clusters,
    required this.events,
  });

  final List<Category> categories;
  final Map<String, List<Cluster>> clusters;
  final List<Event> events;
}
