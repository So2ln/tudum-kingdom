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

  int _popularMoviesPage = 1; // 인기 영화 페이지 번호를 기억할 변수
  bool _isLoadingMore = false; // 추가 로딩 중복 방지

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
    _popularMoviesPage = 1; // 전체 새로고침 시 페이지번호 초기화
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

  // 무한 스크롤을 위한 새 메소드 추가
  Future<void> fetchMorePopularMovies() async {
    if (_isLoadingMore) return; // 이미 로딩 중이면 실행하지 않음
    _isLoadingMore = true;

    _popularMoviesPage++; // 다음 페이지
    final additionalMovies =
        await _fetchPopularMoviesUsecase.execute(page: _popularMoviesPage);

    // 새로 불러온 영화 목록을 기존 목록 뒤에 추가
    state = state.copyWith(
      popularMovies: [...state.popularMovies, ...?additionalMovies],
    );

    _isLoadingMore = false;
  }

  // 새로고침을 위해 다시 호출하는 메소드 추가
  Future<void> refresh() async {
    await fetchAllMovies();
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
