class PaginatedResult<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalResults;

  const PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalResults,
  });

  bool get hasNextPage => currentPage < totalPages;

  PaginatedResult<T> copyWith({List<T>? items, int? currentPage}) {
    return PaginatedResult(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages,
      totalResults: totalResults,
    );
  }
}
