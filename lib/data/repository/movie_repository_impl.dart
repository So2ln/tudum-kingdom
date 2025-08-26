import 'package:tudum_kingdom/data/data_source/movie_data_source.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/domain/entity/movie_detail.dart';
import 'package:tudum_kingdom/domain/repository/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieDataSource _movieDataSource;

  MovieRepositoryImpl(this._movieDataSource);

  @override
  Future<MovieDetail?> fetchMovieDetail(int id) async {
    final result = await _movieDataSource.fetchMovieDetail(id);
    if (result == null) {
      return null;
    }

    return MovieDetail(
      id: result.id,
      title: result.title,
      overview: result.overview,
      releaseDate: result.releaseDate,
      voteAverage: result.voteAverage,
      genres: List.from(result.genres.map((genre) => genre.name)),
      budget: result.budget,
      productionCompanyLogos: List.from(
          result.productionCompanies.map((company) => company.logoPath)),
      popularity: result.popularity,
      revenue: result.revenue,
      runtime: result.runtime,
      tagline: result.tagline,
      voteCount: result.voteCount,
    );
  }

  @override
  Future<List<Movie>?> fetchNowPlayingMovies() async {
    final result = await _movieDataSource.fetchNowPlayingMovies();
    if (result == null) {
      return null;
    }
    return List<Movie>.from(
        //
        result.results.map((movie) => Movie(
              id: movie.id,
              posterPath: movie.posterPath,
            )));
  }

  @override
  Future<List<Movie>?> fetchPopularMovies() async {
    final result = await _movieDataSource.fetchPopularMovies();
    if (result == null) {
      return null;
    }
    return List<Movie>.from(
        //
        result.results.map((movie) => Movie(
              id: movie.id,
              posterPath: movie.posterPath,
            )));
  }

  @override
  Future<List<Movie>?> fetchTopRatedMovies() async {
    final result = await _movieDataSource.fetchTopRatedMovies();
    if (result == null) {
      return null;
    }
    return List<Movie>.from(
        //
        result.results.map((movie) => Movie(
              id: movie.id,
              posterPath: movie.posterPath,
            )));
  }

  @override
  Future<List<Movie>?> fetchUpcomingMovies() async {
    final result = await _movieDataSource.fetchUpcomingMovies();
    if (result == null) {
      return null;
    }
    return List<Movie>.from(
        //
        result.results.map((movie) => Movie(
              id: movie.id,
              posterPath: movie.posterPath,
            )));
  }
  //
}
