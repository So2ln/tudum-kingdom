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

final _fetchMovieDetailUsecaseProvider = Provider(
  (ref) {
    final movieRepository = ref.read(_movieRepositoryProvider);
    return FetchMovieDetailUsecase(movieRepository);
  },
);

final _fetchNowPlayingMoviesUsecaseProvider = Provider(
  (ref) {
    final movieRepository = ref.read(_movieRepositoryProvider);
    return FetchNowPlayingMoviesUsecase(movieRepository);
  },
);

final _fetchPopularMoviesUsecaseProvider = Provider(
  (ref) {
    final movieRepository = ref.read(_movieRepositoryProvider);
    return FetchPopularMoviesUsecase(movieRepository);
  },
);

final _fetchTopRatedMoviesUsecaseProvider = Provider(
  (ref) {
    final movieRepository = ref.read(_movieRepositoryProvider);
    return FetchTopRatedMoviesUsecase(movieRepository);
  },
);

final _fetchUpcomingMoviesUsecaseProvider = Provider(
  (ref) {
    final movieRepository = ref.read(_movieRepositoryProvider);
    return FetchUpcomingMoviesUsecase(movieRepository);
  },
);
