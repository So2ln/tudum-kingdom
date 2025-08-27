import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/domain/repository/movie_repository.dart';

class FetchMoviesByGenreUsecase {
  final MovieRepository _repository;
  FetchMoviesByGenreUsecase(this._repository);

  Future<List<Movie>?> execute({required int genreId}) async {
    return _repository.fetchMoviesByGenre(genreId: genreId);
  }
}
