import 'dart:developer';

import 'package:equatable/equatable.dart';

/// {@template perspective}
/// A perspective on a given new item.
/// {@endtemplate}
class Perspective extends Equatable {
  /// {@macro perspective}
  const Perspective(this.text, this.sources);

  /// Create a [Perspective] from JSON.
  factory Perspective.fromJson(Map<String, dynamic> json) => Perspective(
        json['text'] as String,
        Source.listOf(json['sources'] as List<dynamic>),
      );

  /// Create a list of [Perspective] from a list of JSON objects.
  static List<Perspective> listOf(List<dynamic> list) {
    final perspectives = <Perspective>[];

    for (final i in list) {
      try {
        perspectives.add(Perspective.fromJson(i as Map<String, dynamic>));
      } catch (_) {
        log('Unable to cast list item to Map<String, dynamic>: $i');
      }
    }

    return perspectives;
  }

  /// The text of the [Perspective] to display.
  final String text;

  /// List of sources used to form the perspective.
  final List<Source> sources;

  @override
  List<Object> get props => [text, sources];
}

/// {@template source}
/// Source used to form a [Perspective].
/// {@endtemplate}
class Source extends Equatable {
  /// {@macro source}
  const Source(this.name, this.url);

  /// Create a [Source] object from JSON.
  factory Source.fromJson(Map<String, dynamic> json) => Source(
        json['name'] as String,
        json['url'] as String,
      );

  /// Create a list of [Source] from a list of JSON objects.
  static List<Source> listOf(List<dynamic> list) {
    final sources = <Source>[];

    for (final i in list) {
      try {
        sources.add(Source.fromJson(i as Map<String, dynamic>));
      } catch (_) {
        log('Unable to cast list item to Map<String, dynamic>: $i');
      }
    }

    return sources;
  }

  /// The name of the [Source].
  final String name;

  /// The URL of the [Source].
  final String url;

  @override
  List<Object> get props => [name, url];
}
