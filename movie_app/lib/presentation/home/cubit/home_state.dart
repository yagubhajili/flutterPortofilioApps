import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Movie> trending;
  final List<Movie> popular;
  final List<Movie> topRated;
  final List<Movie> upcoming;

  const HomeLoaded({
    required this.trending,
    required this.popular,
    required this.topRated,
    required this.upcoming,
  });

  @override
  List<Object?> get props => [trending, popular, topRated, upcoming];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
