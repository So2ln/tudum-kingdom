import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:tudum_kingdom/data/data_source/movie_data_source_impl.dart';
import 'package:tudum_kingdom/data/dto/movie_response_dto.dart';

// Dio를 흉내 낼 Mock 객체
class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late MovieDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    // 실제 Dio 대신 MockDio를 사용하도록 DataSource를 설정하는 것이 핵심! (이 부분은 DI 구조에 따라 달라질 수 있음)
    // 지금 구조에서는 DioClient를 직접 Mocking하기 어려우므로, Repository 테스트부터 집중하는 것이 효율적이라고 한다...
  });
}
