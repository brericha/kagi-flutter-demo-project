import 'dart:developer';

import 'package:equatable/equatable.dart';

/// {@template domain}
/// A domain referenced by a Cluster.
/// {@endtemplate}
class Domain extends Equatable {
  /// {@macro domain}
  const Domain(this.name, this.favicon);

  /// Create a [Domain] from JSON.
  factory Domain.fromJson(Map<String, dynamic> json) => Domain(
        json['name'] as String,
        json['favicon'] as String,
      );

  /// Create a list of [Domain] from a list of JSON objects.
  static List<Domain> listOf(List<dynamic> list) {
    final domains = <Domain>[];

    for (final i in list) {
      try {
        domains.add(Domain.fromJson(i as Map<String, dynamic>));
      } catch (_) {
        log('Unable to cast list item to Map<String, dynamic>: $i');
      }
    }

    return domains;
  }

  /// The display name of the domain.
  final String name;

  /// Image URL of the domain's favicon.
  final String favicon;

  @override
  List<Object> get props => [name, favicon];
}
