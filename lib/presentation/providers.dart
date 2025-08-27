// trigger suggestion shortcut : command+i
// F2 를 누르면 전체 명명 변경 가능
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudum_kingdom/data/data_source/movie_data_source.dart';
import 'package:tudum_kingdom/data/data_source/movie_data_source_impl.dart';
import 'package:tudum_kingdom/data/repository/movie_repository_impl.dart';
import 'package:tudum_kingdom/domain/repository/movie_repository.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_movie_detail_usecase.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_now_playing_movies_usecase.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_popular_movies_usecase.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_top_rated_movies_usecase.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_upcoming_movies_usecase.dart';
import 'package:tudum_kingdom/presentation/detail/detail_view_model.dart';
import 'package:tudum_kingdom/presentation/home/home_view_model.dart';

final _movieDataSourceProvider = Provider<MovieDataSource>(
  (ref) {
    return MovieDataSourceImpl();
  },
);

final _movieRepositoryProvider = Provider<MovieRepository>(
  (ref) {
    final dataSource = ref.read(_movieDataSourceProvider);
    return MovieRepositoryImpl(dataSource);
  },
);

final fetchMovieDetailUsecaseProvider = Provider(
  (ref) {
    final movieRepository = ref.read(_movieRepositoryProvider);
    return FetchMovieDetailUsecase(movieRepository);
  },
);

final fetchNowPlayingMoviesUsecaseProvider = Provider(
  (ref) {
    final movieRepository = ref.read(_movieRepositoryProvider);
    return FetchNowPlayingMoviesUsecase(movieRepository);
  },
);

final fetchPopularMoviesUsecaseProvider = Provider(
  (ref) {
    final movieRepository = ref.read(_movieRepositoryProvider);
    return FetchPopularMoviesUsecase(movieRepository);
  },
);

final fetchTopRatedMoviesUsecaseProvider = Provider(
  (ref) {
    final movieRepository = ref.read(_movieRepositoryProvider);
    return FetchTopRatedMoviesUsecase(movieRepository);
  },
);

final fetchUpcomingMoviesUsecaseProvider = Provider(
  (ref) {
    final movieRepository = ref.read(_movieRepositoryProvider);
    return FetchUpcomingMoviesUsecase(movieRepository);
  },
);

// --- Presentation Layer (ViewModels) ---
final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(
    fetchPopularMoviesUsecase: ref.read(fetchPopularMoviesUsecaseProvider),
    fetchNowPlayingMoviesUsecase:
        ref.read(fetchNowPlayingMoviesUsecaseProvider),
    fetchTopRatedMoviesUsecase: ref.read(fetchTopRatedMoviesUsecaseProvider),
    fetchUpcomingMoviesUsecase: ref.read(fetchUpcomingMoviesUsecaseProvider),
  );
});

final detailViewModelProvider =
    StateNotifierProvider.family<DetailViewModel, DetailState, int>(
        (ref, movieId) {
  return DetailViewModel(
    movieId: movieId,
    fetchMovieDetailUsecase: ref.read(fetchMovieDetailUsecaseProvider),
  );
});
