import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/domain/repository/movie_repository.dart';
import 'package:tudum_kingdom/domain/usecase/fetch_popular_movies_usecase.dart';

// MovieRepository를 흉내 낼 가짜(Mock) 객체
class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockRepository;
  late FetchPopularMoviesUsecase usecase;

  // 각 테스트가 실행되기 전에 필요한 객체들을 준비
  setUp(() {
    mockRepository = MockMovieRepository();
    usecase = FetchPopularMoviesUsecase(mockRepository);
  });

  // 테스트할 영화 더미 데이터
  final tMovies = [
    Movie(id: 1, posterPath: '/path1'),
    Movie(id: 2, posterPath: '/path2'),
  ];

  test('UseCase는 Repository로부터 영화 목록을 받아와야 한다', () async {
    // given (준비): Repository가 특정 데이터를 반환하도록 설정
    when(() => mockRepository.fetchPopularMovies(page: 1))
        .thenAnswer((_) async => tMovies);

    // when (실행): UseCase의 execute 메소드 호출
    final result = await usecase.execute(page: 1);

    // then (검증): 결과가 예상과 일치하는지 확인
    expect(result, tMovies);

    // Repository의 fetchPopularMovies 메소드가 page: 1과 함께 정확히 1번 호출되었는지 확인
    verify(() => mockRepository.fetchPopularMovies(page: 1)).called(1);

    // 다른 메소드는 호출되지 않았는지 확인
    verifyNoMoreInteractions(mockRepository);
  });
}
