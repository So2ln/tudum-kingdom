import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/presentation/providers.dart';

class DetailScreen extends ConsumerWidget {
  final Movie movie;
  final String tagHeader;
  const DetailScreen({super.key, required this.movie, required this.tagHeader});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(detailViewModelProvider(movie.id));
    final movieDetail = detailState.movieDetail;

    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: const Color(0xFF0D0D0D),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 500,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: '${tagHeader}_${movie.id}',
                child: Image.network(
                    'https://image.tmdb.org/t/p/original${movie.posterPath}',
                    fit: BoxFit.cover),
              ),
            ),
          ),
          detailState.isLoading
              ? const SliverToBoxAdapter(
                  child: Center(
                    heightFactor: 5.0,
                    child: CircularProgressIndicator(color: Color(0xFFFFD700)),
                  ),
                )
              : SliverList(
                  delegate: SliverChildListDelegate([
                    if (movieDetail != null) // 데이터가 있을 때만 UI를 그려요.
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movieDetail.title,
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 8),
                            if (movieDetail.tagline.isNotEmpty)
                              Text('"${movieDetail.tagline}"',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey)),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                    DateFormat('yyyy.MM.dd')
                                        .format(movieDetail.releaseDate),
                                    style: const TextStyle(color: Colors.grey)),
                                const Text(' • ',
                                    style: TextStyle(color: Colors.grey)),
                                Text('${movieDetail.runtime}분',
                                    style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(movieDetail.genres.join(', '),
                                style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 24),
                            const Text('줄거리',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFD700))),
                            const SizedBox(height: 8),
                            Text(movieDetail.overview,
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
                            if (movieDetail.productionCompanyLogos.isNotEmpty)
                              SizedBox(
                                height: 60,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      movieDetail.productionCompanyLogos.length,
                                  itemBuilder: (context, index) {
                                    final logoPath = movieDetail
                                        .productionCompanyLogos[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: logoPath != null
                                            ? Image.network(
                                                'https://image.tmdb.org/t/p/w200$logoPath')
                                            : Container(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                  ]),
                ),
        ],
      ),
    );
  }
}
