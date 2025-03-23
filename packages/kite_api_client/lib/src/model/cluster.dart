import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:kite_api_client/src/model/article.dart';
import 'package:kite_api_client/src/model/domain.dart';
import 'package:kite_api_client/src/model/perspective.dart';

/// {@template cluster}
/// A Cluster represents one topic within a category.
/// {@endtemplate}
class Cluster extends Equatable {
  /// {@macro cluster}
  const Cluster({
    required this.number,
    required this.uniqueDomains,
    required this.numberOfTitles,
    required this.category,
    required this.title,
    required this.shortSummary,
    required this.didYouKnow,
    required this.talkingPoints,
    required this.quote,
    required this.quoteAuthor,
    required this.quoteSourceUrl,
    required this.quoteSourceDomain,
    required this.location,
    required this.emoji,
    required this.sections,
    required this.perspectives,
    required this.articles,
    required this.domains,
  });

  /// Create a [Cluster] from JSON.
  factory Cluster.fromJson(Map<String, dynamic> json) => Cluster(
        number: json['cluster_number'] as int,
        uniqueDomains: json['unique_domains'] as int,
        numberOfTitles: json['number_of_titles'] as int,
        category: json['category'] as String,
        title: json['title'] as String,
        shortSummary: json['short_summary'] as String,
        didYouKnow: json['did_you_know'] as String,
        talkingPoints:
            (json['talking_points'] as List<dynamic>).map((e) => '$e').toList(),
        quote: json['quote'] as String,
        quoteAuthor: json['quote_author'] as String,
        quoteSourceUrl: json['quote_source_url'] as String,
        quoteSourceDomain: json['quote_source_domain'] as String,
        location: json['location'] as String,
        emoji: json['emoji'] as String,
        perspectives: Perspective.listOf(json['perspectives'] as List<dynamic>),
        articles: Article.listOf(json['articles'] as List<dynamic>),
        domains: Domain.listOf(json['domains'] as List<dynamic>),
        sections: _buildSections(json),
      );

  /// Create a list of [Cluster] from a list of JSON objects.
  static List<Cluster> listOf(List<dynamic> list) {
    final clusters = <Cluster>[];

    for (final i in list) {
      try {
        clusters.add(Cluster.fromJson(i as Map<String, dynamic>));
      } catch (e) {
        log('Unable to cast list item to Map<String, dynamic>: $i');
      }
    }

    return clusters;
  }

  /// Cluster number. Used as ID and order in list.
  final int number;

  /// The number of unique domains referenced by this [Cluster].
  final int uniqueDomains;

  /// The number of titles this [Cluster] contains.
  final int numberOfTitles;

  /// More specific category for this [Cluster].
  final String category;

  /// Title.
  final String title;

  /// Short summary.
  final String shortSummary;

  /// Did you know blurb.
  final String didYouKnow;

  /// Talking points.
  final List<String> talkingPoints;

  /// Quote.
  final String quote;

  /// Author of the [quote].
  final String quoteAuthor;

  /// Source URL of the [quote].
  final String quoteSourceUrl;

  /// Domain of the [quoteSourceUrl].
  final String quoteSourceDomain;

  /// Optional relevant location. Will be an empty String if no value.
  final String location;

  /// An emoji that is relevant to this [Cluster].
  final String emoji;

  /// Additional information about the topic of this [Cluster].
  final Map<String, List<String>> sections;

  /// A list of [Perspective] about the topic of this [Cluster].
  final List<Perspective> perspectives;

  /// A list of [Article] about the topic of this [Cluster].
  final List<Article> articles;

  /// A list of all [Domain] referenced in this [Cluster].
  final List<Domain> domains;

  // JSON keys for the various sections a cluster may contain
  static final _sectionKeys = [
    'geopolitical_context',
    'historical_background',
    'international_reactions',
    'humanitarian_impact',
    'economic_implications',
    'timeline',
    'future_outlook',
    'key_players',
    'technical_details',
    'business_angle_text',
    'business_angle_points',
    'user_action_items',
    'scientific_significance',
    'travel_advisory',
    'destination_highlights',
    'culinary_significance',
    'performance_statistics',
    'league_standings',
    'diy_tips',
    'design_principles',
    'user_experience_impact',
    'gameplay_mechanics',
    'industry_impact',
    'technical_specifications',
  ];

  /// Builds a Map<String, List<String>> for the possible sections for a
  /// Cluster. If a section does not have a value it will not have a value
  /// in the Map. The UI can then iterate over the keys present in this Map
  /// to display the values that are present.
  static Map<String, List<String>> _buildSections(Map<String, dynamic> json) {
    final sections = <String, List<String>>{};

    for (final key in _sectionKeys) {
      final value = json[key];

      // There appear to be four different options this data comes in
      // 1. No value - empty String
      // 2. No value - empty List
      // 3. Value - String
      // 4. Value - List<String>

      if (value is String) {
        // The value is a String. If the String is empty it has no value and
        // can be ignored.
        if (value.isNotEmpty) {
          sections[key] = [value];
        }
      } else if (value is List) {
        // The value is a List. Loop through and double check that all the items
        // are Strings.
        final items = <String>[];
        for (final item in value) {
          if (item is String) {
            items.add(item);
          }
        }

        // Add to the sections map if items is not empty.
        if (items.isNotEmpty) {
          sections[key] = items;
        }
      }
    }

    return sections;
  }

  @override
  List<Object> get props => [
        number,
        uniqueDomains,
        numberOfTitles,
        category,
        title,
        shortSummary,
        didYouKnow,
        talkingPoints,
        quote,
        quoteAuthor,
        quoteSourceUrl,
        quoteSourceDomain,
        location,
        emoji,
        sections,
        perspectives,
        articles,
        domains,
      ];
}
