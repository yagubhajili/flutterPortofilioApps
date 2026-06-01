abstract class ApiConstants {
  static const String bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZTZjZTYzZTk3MzdjZWQyYjgxOGIzMTM5ZGI5ZTQyZCIsIm5iZiI6MTc4MDMyODY4Ni4xNjQsInN1YiI6IjZhMWRhOGVlZDA2ZWU4ZTYzOWFhMTM5NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jTXNqLlJvPdiMiX55M22tpPf6yR9PuP-zWfOhNIgwr8';

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/';

  static const String posterW342 = '${imageBaseUrl}w342';
  static const String posterW500 = '${imageBaseUrl}w500';
  static const String backdropW1280 = '${imageBaseUrl}w1280';
  static const String profileW185 = '${imageBaseUrl}w185';
  static const String original = '${imageBaseUrl}original';

  // Endpoints
  static const String trending = '/trending/movie/week';
  static const String popular = '/movie/popular';
  static const String topRated = '/movie/top_rated';
  static const String upcoming = '/movie/upcoming';
  static const String movieDetail = '/movie';
  static const String searchMovie = '/search/movie';
  static const String movieGenres = '/genre/movie/list';
  static const String discoverMovie = '/discover/movie';
  static const String person = '/person';
  static const String trendingTv = '/trending/tv/week';
  static const String popularTv = '/tv/popular';
  static const String topRatedTv = '/tv/top_rated';
  static const String tvDetail = '/tv';
  static const String searchTv = '/search/tv';
  static const String tvGenres = '/genre/tv/list';
}
