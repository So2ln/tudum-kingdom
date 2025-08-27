import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/presentation/providers.dart';
import 'package:tudum_kingdom/presentation/widgets/falling_star.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final Movie movie;
  final String tagHeader;
  const DetailScreen({super.key, required this.movie, required this.tagHeader});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen>
    with TickerProviderStateMixin {
// 애니메이션 추가!
  late final List<Widget> _stars;

  @override
  void initState() {
    super.initState();
    // '인기순' 목록에서 왔을 때 별똥별 효과!
    if (widget.tagHeader == 'choice') {
      _stars = List.generate(100, (_) => const FallingStar());
    } else {
      _stars = []; // 다른 목록은 빈 리스트
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(detailViewModelProvider(widget.movie.id));
    final movieDetail = detailState.movieDetail;

    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // 1. 배경 레이어: '인기순' 영화일 때만 별똥별 나오게
          if (widget.tagHeader == 'choice')
            Positioned.fill(
              child: Stack(children: _stars),
            ),

          // 2. 내용 레이어: 영화 정보
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () {
                    // go_router의 뒤로가기 기능
                    context.pop();
                  },
                ),
                expandedHeight: 500,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: '${widget.tagHeader}_${widget.movie.id}',
                    child: Image.network(
                        'https://image.tmdb.org/t/p/original${widget.movie.posterPath}',
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              detailState.isLoading
                  ? const SliverToBoxAdapter(
                      child: Center(
                        heightFactor: 5.0,
                        child:
                            CircularProgressIndicator(color: Color(0xFFFFD700)),
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
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                    const Text(' • ',
                                        style: TextStyle(color: Colors.grey)),
                                    Text('${movieDetail.runtime}분',
                                        style: const TextStyle(
                                            color: Colors.grey)),
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
                                if (movieDetail
                                    .productionCompanyLogos.isNotEmpty)
                                  SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: movieDetail
                                          .productionCompanyLogos.length,
                                      itemBuilder: (context, index) {
                                        final logoPath = movieDetail
                                            .productionCompanyLogos[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16.0),
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
        ],
      ),
    );
  }
}
