import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudum_kingdom/domain/entity/movie_detail.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_movie_detail_usecase.dart';

class DetailViewModel extends StateNotifier<DetailState> {
  final int _movieId;
  final FetchMovieDetailUsecase _fetchMovieDetailUsecase;

  DetailViewModel(
      {required int movieId,
      required FetchMovieDetailUsecase fetchMovieDetailUsecase})
      : _movieId = movieId,
        _fetchMovieDetailUsecase = fetchMovieDetailUsecase,
        super(DetailState()) {
    fetchMovieDetail();
  }

  Future<void> fetchMovieDetail() async {
    state = state.copyWith(isLoading: true);
    final movieDetail = await _fetchMovieDetailUsecase.execute(_movieId);
    state = state.copyWith(movieDetail: movieDetail, isLoading: false);
  }
}

class DetailState {
  final MovieDetail? movieDetail;
  final bool isLoading;

  DetailState({
    this.movieDetail,
    this.isLoading = true,
  });

  DetailState copyWith({
    MovieDetail? movieDetail,
    bool? isLoading,
  }) {
    return DetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
