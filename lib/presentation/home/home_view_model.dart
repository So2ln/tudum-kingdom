import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_now_playing_movies_usecase.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_popular_movies_usecase.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_top_rated_movies_usecase.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_upcoming_movies_usecase.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final FetchPopularMoviesUsecase _fetchPopularMoviesUsecase;
  final FetchNowPlayingMoviesUsecase _fetchNowPlayingMoviesUsecase;
  final FetchTopRatedMoviesUsecase _fetchTopRatedMoviesUsecase;
  final FetchUpcomingMoviesUsecase _fetchUpcomingMoviesUsecase;

  HomeViewModel({
    required FetchPopularMoviesUsecase fetchPopularMoviesUsecase,
    required FetchNowPlayingMoviesUsecase fetchNowPlayingMoviesUsecase,
    required FetchTopRatedMoviesUsecase fetchTopRatedMoviesUsecase,
    required FetchUpcomingMoviesUsecase fetchUpcomingMoviesUsecase,
  })  : _fetchPopularMoviesUsecase = fetchPopularMoviesUsecase,
        _fetchNowPlayingMoviesUsecase = fetchNowPlayingMoviesUsecase,
        _fetchTopRatedMoviesUsecase = fetchTopRatedMoviesUsecase,
        _fetchUpcomingMoviesUsecase = fetchUpcomingMoviesUsecase,
        super(HomeState()) {
    fetchAllMovies();
  }
  Future<void> fetchAllMovies() async {
    state = state.copyWith(isLoading: true);
    final results = await Future.wait([
      _fetchPopularMoviesUsecase.execute(page: 1),
      _fetchNowPlayingMoviesUsecase.execute(),
      _fetchTopRatedMoviesUsecase.execute(),
      _fetchUpcomingMoviesUsecase.execute(),
    ]);
    state = state.copyWith(
      popularMovies: results[0] ?? [],
      nowPlayingMovies: results[1] ?? [],
      topRatedMovies: results[2] ?? [],
      upcomingMovies: results[3] ?? [],
      isLoading: false,
    );
  }
}

class HomeState {
  final List<Movie> popularMovies;
  final List<Movie> nowPlayingMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;
  final bool isLoading;

  HomeState({
    this.popularMovies = const [],
    this.nowPlayingMovies = const [],
    this.topRatedMovies = const [],
    this.upcomingMovies = const [],
    this.isLoading = true,
  });

  HomeState copyWith({
    List<Movie>? popularMovies,
    List<Movie>? nowPlayingMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? upcomingMovies,
    bool? isLoading,
  }) {
    return HomeState(
      popularMovies: popularMovies ?? this.popularMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
