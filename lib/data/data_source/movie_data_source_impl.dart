import 'dart:convert';
import 'package:tudum_kingdom/data/data_source/movie_data_source.dart';
import 'package:tudum_kingdom/data/dto/movie_detail_dto.dart';
import 'package:tudum_kingdom/data/dto/movie_response_dto.dart';
import 'package:tudum_kingdom/dio_client.dart';

class MovieDataSourceImpl implements MovieDataSource {
  @override
  Future<MovieDetailDto?> fetchMovieDetail(int id) async {
    final response = await DioClient.client.get(
      '/movie/$id',
      queryParameters: {
        'language': 'ko-KR',
      },
    );
    final json = jsonDecode(response.toString());
    return MovieDetailDto.fromJson(json);
  }

  @override
  Future<MovieResponseDto?> fetchNowPlayingMovies() async {
    final response = await DioClient.client.get(
      '/movie/now_playing',
      queryParameters: {
        'language': 'ko-KR',
      },
    );
    final json = jsonDecode(response.toString());
    return MovieResponseDto.fromJson(json);
  }

  @override
  Future<MovieResponseDto?> fetchPopularMovies({required int page}) async {
    final response = await DioClient.client.get(
      '/movie/popular',
      queryParameters: {
        'language': 'ko-KR',
        'page': page,
      },
    );
    final json = jsonDecode(response.toString());
    return MovieResponseDto.fromJson(json);
  }

  @override
  Future<MovieResponseDto?> fetchTopRatedMovies() async {
    final response = await DioClient.client.get(
      '/movie/top_rated',
      queryParameters: {
        'language': 'ko-KR',
      },
    );
    final json = jsonDecode(response.toString());
    return MovieResponseDto.fromJson(json);
  }

  @override
  Future<MovieResponseDto?> fetchUpcomingMovies() async {
    final response = await DioClient.client.get(
      '/movie/upcoming',
      queryParameters: {
        'language': 'ko-KR',
      },
    );
    final json = jsonDecode(response.toString());
    return MovieResponseDto.fromJson(json);
  }

  @override
  Future<MovieResponseDto?> fetchMoviesByGenre({required int genreId}) async {
    final response =
        await DioClient.client.get('/discover/movie', queryParameters: {
      'with_genres': genreId,
      'language': 'ko-KR',
    });
    return MovieResponseDto.fromJson(response.data);
  }
}
