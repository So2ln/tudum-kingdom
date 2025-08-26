import 'package:tudum_kingdom/data/dto/movie_detail_dto.dart';
import 'package:tudum_kingdom/data/dto/movie_response_dto.dart';

abstract interface class MovieDataSource {
  Future<MovieResponseDto?> fetchNowPlayingMovies();

  Future<MovieResponseDto?> fetchPopularMovies({required int page});

  Future<MovieResponseDto?> fetchTopRatedMovies();

  Future<MovieResponseDto?> fetchUpcomingMovies();

  Future<MovieDetailDto?> fetchMovieDetail(int id);
}
