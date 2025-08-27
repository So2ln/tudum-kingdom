import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tudum_kingdom/data/data_source/movie_data_source.dart';
import 'package:tudum_kingdom/data/dto/movie_response_dto.dart';
import 'package:tudum_kingdom/data/repository/movie_repository_impl.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';

class MockMovieDataSource extends Mock implements MovieDataSource {}

void main() {
  late MockMovieDataSource mockDataSource;
  late MovieRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockMovieDataSource();
    repository = MovieRepositoryImpl(mockDataSource);
  });

  test('fetchPopularMovies가 DTO를 Movie Entity 리스트로 잘 변환하는지 테스트', () async {
    // given: mockDataSource가 특정 DTO를 반환하도록 설정
    final mockDto =
        MovieResponseDto(page: 1, totalPages: 1, totalResults: 1, results: [
      Result(
        // 이 테스트에서 중요한 데이터 3개
        id: 1,
        title: 'Test Movie',
        posterPath: '/path',

// 객체 생성을 위한 필수 값들
        adult: false,
        backdropPath: '',
        genreIds: [],
        originalLanguage: 'en',
        originalTitle: '',
        overview: '',
        popularity: 0.0,
        releaseDate: DateTime.now(),
        video: false,
        voteAverage: 0.0,
        voteCount: 0,
      ),
    ]);
    when(() => mockDataSource.fetchPopularMovies(page: 1))
        .thenAnswer((_) async => mockDto);

    // when: repository의 메소드 호출
    final result = await repository.fetchPopularMovies(page: 1);

    // then: 결과가 Movie Entity 리스트인지, 값이 올바른지 확인
    expect(result, isA<List<Movie>>());
    expect(result!.first.id, 1);
    expect(result.first.posterPath, '/path');
  });
}
