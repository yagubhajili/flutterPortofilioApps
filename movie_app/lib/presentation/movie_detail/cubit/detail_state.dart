import 'package:equatable/equatable.dart';
import '../../../domain/entities/cast_member.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../../domain/entities/video.dart';

abstract class DetailState extends Equatable {
  const DetailState();
  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final MovieDetail detail;
  final List<CastMember> cast;
  final List<Video> videos;
  final List<Movie> similar;

  const DetailLoaded({
    required this.detail,
    this.cast = const [],
    this.videos = const [],
    this.similar = const [],
  });

  Video? get trailer => videos
      .where((v) => v.isYoutube && v.isTrailer)
      .fold<Video?>(null, (best, v) => v.official ? v : (best ?? v));

  @override
  List<Object?> get props => [detail, cast, videos, similar];
}

class DetailError extends DetailState {
  final String message;
  const DetailError(this.message);
  @override
  List<Object?> get props => [message];
}
