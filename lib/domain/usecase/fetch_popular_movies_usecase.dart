import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/domain/repository/movie_repository.dart';

class FetchPopularMoviesUsecase {
  FetchPopularMoviesUsecase(this.movieRepository);

  final MovieRepository movieRepository;

  Future<List<Movie>?> execute({required int page}) async {
    return await movieRepository.fetchPopularMovies(page: page);
  }
}
