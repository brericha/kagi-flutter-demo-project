import 'dart:developer';

import 'package:equatable/equatable.dart';

/// {@template category}
/// Represents a news category.
/// {@endtemplate}
class Category extends Equatable {
  /// {@macro category}
  const Category(
    this.name,
    this.file,
  );

  /// Create a [Category] from JSON.
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        json['name'] as String,
        json['file'] as String,
      );

  /// Create a list of [Category] from a list of JSON objects.
  static List<Category> listOf(List<dynamic> list) {
    final categories = <Category>[];

    for (final i in list) {
      try {
        categories.add(Category.fromJson(i as Map<String, dynamic>));
      } catch (_) {
        log('Unable to cast list item to Map<String, dynamic>: $i');
      }
    }

    return categories;
  }

  /// The user-facing name of this category.
  final String name;

  /// The API endpoint used to fetch the stories for this category.
  final String file;

  @override
  List<Object> get props => [name, file];
}
