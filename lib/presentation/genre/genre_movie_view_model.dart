import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_movies_by_genre_usecase.dart';

class GenreMovieState {
  final List<Movie> movies;
  final bool isLoading;
  GenreMovieState({this.movies = const [], this.isLoading = true});

  GenreMovieState copyWith({List<Movie>? movies, bool? isLoading}) {
    return GenreMovieState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GenreMovieViewModel extends StateNotifier<GenreMovieState> {
  final int _genreId;
  final FetchMoviesByGenreUsecase _usecase;

  GenreMovieViewModel(this._genreId, this._usecase) : super(GenreMovieState()) {
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    state = state.copyWith(isLoading: true);
    final movies = await _usecase.execute(genreId: _genreId);
    state = state.copyWith(movies: movies ?? [], isLoading: false);
  }
}
