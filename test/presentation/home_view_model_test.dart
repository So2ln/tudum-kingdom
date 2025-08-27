import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_now_playing_movies_usecase.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_popular_movies_usecase.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_top_rated_movies_usecase.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_upcoming_movies_usecase.dart';
import 'package:tudum_kingdom/presentation/home/home_view_model.dart';
import 'package:tudum_kingdom/presentation/providers.dart';

// 모든 UseCase들을 흉내 낼 가짜(Mock) 객체들을 생성
class MockFetchPopularMoviesUsecase extends Mock
    implements FetchPopularMoviesUsecase {}

class MockFetchNowPlayingMoviesUsecase extends Mock
    implements FetchNowPlayingMoviesUsecase {}

class MockFetchTopRatedMoviesUsecase extends Mock
    implements FetchTopRatedMoviesUsecase {}

class MockFetchUpcomingMoviesUsecase extends Mock
    implements FetchUpcomingMoviesUsecase {}

void main() {
  // 테스트에 필요한 객체들을 선언
  late ProviderContainer container;
  late MockFetchPopularMoviesUsecase mockPopularUsecase;
  late MockFetchNowPlayingMoviesUsecase mockNowPlayingUsecase;
  late MockFetchTopRatedMoviesUsecase mockTopRatedUsecase;
  late MockFetchUpcomingMoviesUsecase mockUpcomingUsecase;

  // 더미 데이터
  final tMovies = [Movie(id: 1, posterPath: '/path')];

  setUp(() {
    // 각 Mock 객체들을 초기화
    mockPopularUsecase = MockFetchPopularMoviesUsecase();
    mockNowPlayingUsecase = MockFetchNowPlayingMoviesUsecase();
    mockTopRatedUsecase = MockFetchTopRatedMoviesUsecase();
    mockUpcomingUsecase = MockFetchUpcomingMoviesUsecase();

    // ProviderContainer를 생성하고, 실제 Provider들을 Mock 객체로 덮어씌움(override).
    // 이렇게 하면 ViewModel은 실제 UseCase 대신 우리가 제어하는 Mock UseCase를 사용하게 된다
    container = ProviderContainer(
      overrides: [
        fetchPopularMoviesUsecaseProvider.overrideWithValue(mockPopularUsecase),
        fetchNowPlayingMoviesUsecaseProvider
            .overrideWithValue(mockNowPlayingUsecase),
        fetchTopRatedMoviesUsecaseProvider
            .overrideWithValue(mockTopRatedUsecase),
        fetchUpcomingMoviesUsecaseProvider
            .overrideWithValue(mockUpcomingUsecase),
      ],
    );

    // 각 UseCase가 호출될 때 더미 데이터를 반환하도록 미리 설정
    when(() => mockPopularUsecase.execute(page: any(named: 'page')))
        .thenAnswer((_) async => tMovies);
    when(() => mockNowPlayingUsecase.execute())
        .thenAnswer((_) async => tMovies);
    when(() => mockTopRatedUsecase.execute()).thenAnswer((_) async => tMovies);
    when(() => mockUpcomingUsecase.execute()).thenAnswer((_) async => tMovies);
  });

  // 각 테스트가 끝난 후 ProviderContainer를 정리
  tearDown(() {
    container.dispose();
  });

  test('HomeViewModel이 생성될 때 초기 상태는 isLoading=true여야 한다', () {
    // when: ViewModel의 초기 상태를 읽어옴
    final initialState = container.read(homeViewModelProvider);
    // then: 초기 상태가 올바른지 확인합니다.
    expect(initialState.isLoading, isTrue);
    expect(initialState.popularMovies, isEmpty);
  });

  test('fetchAllMovies가 성공적으로 호출되면, 상태가 업데이트되고 isLoading=false가 되어야 한다',
      () async {
    // given (준비): setUp에서 이미 Mock UseCase들이 데이터를 반환하도록

    // when (실행): ViewModel의 fetchAllMovies 메소드를 호출
    // ProviderContainer는 ViewModel의 생성을 지연시키므로, 테스트 시작 시점에 명시적으로 읽어와서 초기화
    final viewModel = container.read(homeViewModelProvider.notifier);
//
    // fetchAllMovies가 완료될 때까지 기다림
    await container.pump();

    // then (검증): 최종 상태를 읽어와서 올바르게 업데이트되었는지 확인
    final finalState = container.read(homeViewModelProvider);

    expect(finalState.isLoading, isFalse);
    expect(finalState.popularMovies.length, 1);
    expect(finalState.popularMovies.first.id, 1);
    expect(finalState.nowPlayingMovies, isNotEmpty);
    expect(finalState.topRatedMovies, isNotEmpty);
    expect(finalState.upcomingMovies, isNotEmpty);
  });
}
