import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/presentation/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);

    if (homeState.isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF0D0D0D),
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFFFFD700))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff0d0d0d),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 섹션 1: 가장 인기있는 영화 이미지 (배너)
              if (homeState.popularMovies.isNotEmpty)
                _buildMainBanner(context, homeState.popularMovies.first),

              const SizedBox(height: 30),

              // 섹션 2: 현재 상영중 (가로 리스트)
              _buildMovieListSection(
                context: context,
                title: '현재 상영중',
                movies: homeState.nowPlayingMovies,
                tagHeader: 'movie_list',
              ),

              // 섹션 3: 인기순 (가로 리스트 + 랭킹)
              _buildMovieListSection(
                context: context,
                title: '인기순',
                movies: homeState.popularMovies,
                showRank: true, // 인기순 목록에만 랭킹 표시
                tagHeader: 'popularity',
              ),

              // 섹션 4: 평점 높은 순 (가로 리스트)
              _buildMovieListSection(
                context: context,
                title: '평점 높은 순',
                movies: homeState.topRatedMovies,
                tagHeader: 'top_rated',
              ),

              // 섹션 5: 개봉 예정 (가로 리스트)
              _buildMovieListSection(
                context: context,
                title: '개봉 예정',
                movies: homeState.upcomingMovies,
                tagHeader: 'upcoming',
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainBanner(BuildContext context, Movie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.go('/detail/${movie.id}', extra: movie),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Hero(
            tag: 'movie_${movie.id}',
            child: Image.network(
              'https://image.tmdb.org/t/p/original${movie.posterPath}',
              fit: BoxFit.cover,
            ),
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
    required String tagHeader,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180, // 리스트뷰 높이 180
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (context, index) {
              return _buildMovieListItem(
                tagHeader: tagHeader,
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
    required String tagHeader,
  }) {
    Map<String, dynamic> data = {
      'movie': movie,
      'tagHeader': tagHeader,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () => context.go(
          '/detail/${movie.id}',
          extra: data,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Hero(
                tag: '${tagHeader}_${movie.id}',
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              if (showRank)
                Text(
                  '$rank',
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black54),
                ),
              if (showRank)
                Text(
                  '$rank',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
