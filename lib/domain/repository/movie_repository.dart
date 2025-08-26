// convert DTO to Entity

import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/domain/entity/movie_detail.dart';

abstract interface class MovieRepository {
  Future<List<Movie>?> fetchNowPlayingMovies();

  Future<List<Movie>?> fetchPopularMovies({required int page});

  Future<List<Movie>?> fetchTopRatedMovies();

  Future<List<Movie>?> fetchUpcomingMovies();

  Future<MovieDetail?> fetchMovieDetail(int id);
}
