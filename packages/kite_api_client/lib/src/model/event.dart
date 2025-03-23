import 'dart:developer';

import 'package:equatable/equatable.dart';

/// {@template event}
/// An event from the OnThisDay category.
/// {@endtemplate}
class Event extends Equatable {
  /// {@macro event}
  const Event({
    required this.year,
    required this.sortYear,
    required this.content,
    required this.type,
  });

  /// Create an [Event] from JSON.
  factory Event.fromJson(Map<String, dynamic> json) => Event(
        year: json['year'] as String,
        sortYear: json['sort_year'] as num,
        content: json['content'] as String,
        type: json['type'] as String,
      );

  /// Create a list of [Event] from a list of JSON objects.
  static List<Event> listOf(List<dynamic> list) {
    final events = <Event>[];

    for (final i in list) {
      try {
        events.add(Event.fromJson(i as Map<String, dynamic>));
      } catch (_) {
        log('Unable to cast list item to Map<String, dynamic>: $i');
      }
    }

    return events;
  }

  /// The year this [Event] happened.
  final String year;

  /// Year and optional decimal used to sort events that occurred in the same
  /// year.
  final num sortYear;

  /// The content of the [Event]. Contains HTML tags.
  final String content;

  /// The type of this event: one of: event, people.
  final String type;

  @override
  List<Object> get props => [year, sortYear, content, type];
}
