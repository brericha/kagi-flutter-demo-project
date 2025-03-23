import 'package:equatable/equatable.dart';
import 'package:kite_api_client/src/model/cluster.dart';

/// {@template category_response}
/// A response for a specific category.
/// {@endtemplate}
class CategoryResponse extends Equatable {
  /// {@macro category_response}
  const CategoryResponse({
    required this.category,
    required this.timestamp,
    required this.read,
    required this.clusters,
  });

  /// Create a [CategoryResponse] from JSON.
  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        category: json['category'] as String,
        timestamp: json['timestamp'] as int,
        read: json['read'] as int,
        clusters: Cluster.listOf(json['clusters'] as List<dynamic>),
      );

  /// Category title.
  final String category;

  /// When the data for this category was last updated.
  final int timestamp;

  /// Unknown.
  final int read;

  /// List of [Cluster]s for this category.
  final List<Cluster> clusters;

  @override
  List<Object> get props => [category, timestamp, read, clusters];
}
