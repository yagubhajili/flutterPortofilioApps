import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/cast_member.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../../domain/entities/video.dart';
import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_tv_detail.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieCredits getMovieCredits;
  final GetMovieVideos getMovieVideos;
  final GetSimilarMovies getSimilarMovies;
  final GetTvDetail getTvDetail;
  final GetTvCredits getTvCredits;
  final GetTvVideos getTvVideos;
  final GetSimilarTv getSimilarTv;

  DetailCubit({
    required this.getMovieDetail,
    required this.getMovieCredits,
    required this.getMovieVideos,
    required this.getSimilarMovies,
    required this.getTvDetail,
    required this.getTvCredits,
    required this.getTvVideos,
    required this.getSimilarTv,
  }) : super(DetailInitial());

  Future<void> load(int id, {bool isTv = false}) async {
    emit(DetailLoading());

    final detailEither =
        isTv ? await getTvDetail(id) : await getMovieDetail(id);

    MovieDetail? detail;
    String? error;
    detailEither.fold((f) => error = f.message, (d) => detail = d);

    if (error != null || detail == null) {
      emit(DetailError(error ?? 'Naməlum xəta'));
      return;
    }

    // Run remaining calls in parallel with typed futures
    final castFuture =
        isTv ? getTvCredits(id) : getMovieCredits(id);
    final videosFuture =
        isTv ? getTvVideos(id) : getMovieVideos(id);
    final similarFuture =
        isTv ? getSimilarTv(id) : getSimilarMovies(id);

    final castEither = await castFuture;
    final videosEither = await videosFuture;
    final similarEither = await similarFuture;

    List<CastMember> cast = castEither.getOrElse(() => []);
    List<Video> videos = videosEither.getOrElse(() => []);
    List<Movie> similar = similarEither.getOrElse(() => throw Exception()).items;

    emit(DetailLoaded(
      detail: detail!,
      cast: cast,
      videos: videos,
      similar: similar,
    ));
  }
}
