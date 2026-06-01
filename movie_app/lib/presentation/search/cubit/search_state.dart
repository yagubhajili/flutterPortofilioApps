import 'package:equatable/equatable.dart';
import '../../../domain/entities/genre.dart';
import '../../../domain/entities/movie.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  final List<Genre> genres;
  const SearchInitial({this.genres = const []});
  @override
  List<Object?> get props => [genres];
}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Movie> results;
  final String query;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;

  const SearchLoaded({
    required this.results,
    required this.query,
    required this.currentPage,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  bool get hasMore => currentPage < totalPages;

  SearchLoaded copyWith({
    List<Movie>? results,
    int? currentPage,
    bool? isLoadingMore,
  }) =>
      SearchLoaded(
        results: results ?? this.results,
        query: query,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );

  @override
  List<Object?> get props => [results, query, currentPage, isLoadingMore];
}

class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty(this.query);
  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object?> get props => [message];
}
