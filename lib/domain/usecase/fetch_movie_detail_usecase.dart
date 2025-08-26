import 'package:tudum_kingdom/domain/entity/movie_detail.dart';
import 'package:tudum_kingdom/domain/repository/movie_repository.dart';

class FetchMovieDetailUseCase {
  FetchMovieDetailUseCase(this.movieRepository);

  final MovieRepository movieRepository;

  Future<MovieDetail?> execute(int id) async {
    return await movieRepository.fetchMovieDetail(id);
  }
}
