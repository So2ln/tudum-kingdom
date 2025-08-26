import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';

class HomeScreen extends StatelessWidget {
  // 가라데이터 (viewmodel연결하기)
  final dummyMovies = [
    Movie(id: 1, posterPath: '/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg'),
    Movie(id: 2, posterPath: '/s9YTxwaByYeoSqugYjIft0THAz.jpg'),
    Movie(id: 3, posterPath: '/fZv4EldEPurSz0d2uD3Wd7bH6G.jpg'),
    Movie(id: 4, posterPath: '/A4s4sES2iOJ32I22T0Hquro1J6p.jpg'),
    Movie(id: 5, posterPath: '/ptwhs3oP54P5bI3VovsHh2zawe0.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff0d0d0d),
        body: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 20),
              _buildMainBanner(context, dummyMovies.first),
              SizedBox(height: 30),
              _buildMovieListSection(
                context: context,
                title: '가장 인기있는',
                movies: dummyMovies,
                showRank: true,
              ),
              _buildMovieListSection(
                context: context,
                title: '현재 상영중',
                movies: dummyMovies,
              ),
              _buildMovieListSection(
                context: context,
                title: '인기순',
                movies: dummyMovies,
              ),
              _buildMovieListSection(
                context: context,
                title: '평점 높은 순',
                movies: dummyMovies,
              ),
              _buildMovieListSection(
                context: context,
                title: '개봉 예정',
                movies: dummyMovies,
              ),
              SizedBox(
                height: 20,
              )
            ]),
          ),
        ));
  }

  Widget _buildMainBanner(BuildContext context, Movie movie) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          print("메인 배너 영화 ID: ${movie.id} 탭됨!");
          // 나중에 여기에 네비게이션 넣기
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Hero(
            tag: 'movie_${movie.id}',
            child: Image.network(
                'https://image.tmdb.org/t/p/original${movie.posterPath}'),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieListSection({
    required BuildContext context,
    required String title,
    required List<Movie> movies,
    bool showRank = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(title,
              style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (context, index) {
              return _buildMovieListItem(
                context: context,
                movie: movies[index],
                rank: index + 1,
                showRank: showRank,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMovieListItem({
    required BuildContext context,
    required Movie movie,
    required int rank,
    required bool showRank,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          print("리스트 영화 ID: ${movie.id} 탭됨!");
          // 나중에 여기에 내비게이션 코드
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Hero(
                tag: 'movie_${movie.id}',
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              if (showRank)
                Text('$rank',
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.black.withOpacity(0.7))),
              if (showRank)
                Text('$rank',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
