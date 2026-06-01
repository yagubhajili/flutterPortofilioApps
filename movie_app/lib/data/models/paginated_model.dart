import '../../domain/entities/paginated_result.dart';

class PaginatedModel<T> extends PaginatedResult<T> {
  const PaginatedModel({
    required super.items,
    required super.currentPage,
    required super.totalPages,
    required super.totalResults,
  });

  factory PaginatedModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final results = (json['results'] as List<dynamic>? ?? [])
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
    return PaginatedModel(
      items: results,
      currentPage: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalResults: json['total_results'] as int? ?? 0,
    );
  }
}
