import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/domain/entity/movie_detail.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({required this.movie});
  final Movie movie; // HomeScreen에서 Hero 애니메이션을 위해 받기!

  @override
  Widget build(BuildContext context) {
    // --- 나중에 ViewModel로 불러올 가라정보 ---
    final dummyDetail = MovieDetail(
      id: movie.id,
      title: '가짜 영화 제목',
      tagline: '테그라인',
      overview: '오버뷰오버뷰오버뷰오버뷰오버뷰오버뷰오버뷰오버뷰오버뷰오버뷰오버뷰오버뷰오버뷰오버뷰오버뷰',
      releaseDate: DateTime.now(),
      runtime: 120,
      genres: ['판타지', '모험', '코미디'],
      voteAverage: 8.5,
      budget: 100000000,
      revenue: 500000000,
      popularity: 1234.56,
      voteCount: 5000,
      productionCompanyLogos: [
        '/wwemzKWzjKYJFfCeiB57q3r4Bcm.png', // Disney 로고
        '/o86DbpburjxrqAzEDhXZcyE8pDb.png', // Pixar 로고
      ],
    );
    // ----------------------------------------------------

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 500,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'movie_${movie.id}',
                child: Image.network(
                  'https://image.tmdb.org/t/p/original${movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dummyDetail.title,
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      if (dummyDetail.tagline.isNotEmpty)
                        Text('"${dummyDetail.tagline}"',
                            style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                              DateFormat('yyyy.MM.dd')
                                  .format(dummyDetail.releaseDate),
                              style: const TextStyle(color: Colors.grey)),
                          const Text(' • ',
                              style: TextStyle(color: Colors.grey)),
                          Text('${dummyDetail.runtime}분',
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(dummyDetail.genres.join(', '),
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 24),
                      const Text('줄거리',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD700))),
                      const SizedBox(height: 8),
                      Text(dummyDetail.overview,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.5)),
                      const SizedBox(height: 24),
                      const Text('제작사',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD700))),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dummyDetail.productionCompanyLogos.length,
                          itemBuilder: (context, index) {
                            final logoPath =
                                dummyDetail.productionCompanyLogos[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.network(
                                    'https://image.tmdb.org/t/p/w200$logoPath'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
