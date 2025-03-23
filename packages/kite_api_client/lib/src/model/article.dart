import 'dart:developer';

import 'package:equatable/equatable.dart';

/// {@template article}
/// A linked article.
/// {@endtemplate}
class Article extends Equatable {
  /// {@macro article}
  const Article({
    required this.title,
    required this.link,
    required this.domain,
    this.image,
    this.imageCaption,
  });

  /// Create an [Article] from JSON.
  factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json['title'] as String,
        link: json['link'] as String,
        domain: json['domain'] as String,
        image: json['image'] as String?,
        imageCaption: json['image_caption'] as String?,
      );

  /// Create a list of [Article] from a list of JSON objects.
  static List<Article> listOf(List<dynamic> list) {
    final articles = <Article>[];

    for (final i in list) {
      try {
        articles.add(Article.fromJson(i as Map<String, dynamic>));
      } catch (_) {
        log('Unable to cast list item to Map<String, dynamic>: $i');
      }
    }

    return articles;
  }

  /// Article title.
  final String title;

  /// Article URL.
  final String link;

  /// Article domain.
  final String domain;

  /// Optional image URL.
  final String? image;

  /// Optional image caption.
  final String? imageCaption;

  @override
  List<Object?> get props => [title, link, domain, image, imageCaption];
}
