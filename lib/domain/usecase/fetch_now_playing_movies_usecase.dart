import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/domain/repository/movie_repository.dart';

class FetchNowPlayingMoviesUseCase {
  FetchNowPlayingMoviesUseCase(this.movieRepository);

  final MovieRepository movieRepository;

  Future<List<Movie>?> execute() async {
    return await movieRepository.fetchNowPlayingMovies();
  }
}
