import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/domain/entity/movie_detail.dart';
import 'package:tudum_kingdom/presentation/providers.dart';
import 'package:tudum_kingdom/presentation/theme/build_context_ext.dart';
import 'package:tudum_kingdom/presentation/widgets/falling_star.dart';
import 'package:tudum_kingdom/presentation/widgets/golden_text.dart';

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
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // '인기순' 목록에서 왔을 때 별똥별 효과!
    if (widget.tagHeader == 'choice') {
      _stars = List.generate(
          50,
          (_) => FallingStar(
              delay: Duration(milliseconds: _random.nextInt(5000))));
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
      backgroundColor: context.colors.deepPurpleNight,
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
                expandedHeight: context.sh * 0.4,
                pinned: true,
                //아 stretch가 true가 아니었어서 아래 화면 당길때 이미지 늘어나는 효과가 안됐었음
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  //    스크롤할 때 배경이 천천히 따라 움직이게 만들기! (사실 기본값이라 안써도 됨)
                  collapseMode: CollapseMode.parallax,
                  // 화면을 위로 더 당겼을 때 이미지가 살짝 늘어나는 효과
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: Hero(
                    tag: '${widget.tagHeader}_${widget.movie.id}',
                    child: widget.movie.posterPath != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/original${widget.movie.posterPath}',
                            fit: BoxFit.cover)
                        : SizedBox.shrink(),
                  ),
                ),
              ),
              detailState.isLoading
                  ? SliverToBoxAdapter(
                      child: Center(
                        heightFactor: 5.0,
                        child: CircularProgressIndicator(
                            color: context.colors.mistyLavender),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildListDelegate([
                        if (movieDetail != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. 제목과 개봉일
                                _buildHeader(context, movieDetail),
                                // 2. 태그라인
                                if (movieDetail.tagline.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  _buildTagline(context, movieDetail),
                                ],
                                // 3. 런타임
                                _buildRuntime(context, movieDetail),
                                const SizedBox(height: 10),

                                // 4. 키워드 위아래 구분선
                                _buildDivider(context),
                                const SizedBox(height: 12),
                                _buildGenreTags(context, movieDetail),
                                const SizedBox(height: 12),
                                _buildDivider(context),
                                const SizedBox(height: 16),

                                // 5. 줄거리
                                Text(movieDetail.overview,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        height: 1.5)),
                                const SizedBox(height: 16),

                                // 6. 흥행 정보
                                _buildDivider(context),
                                const SizedBox(height: 12),
                                _buildBoxOfficeInfo(context, movieDetail),
                                const SizedBox(height: 20),

                                // 7. 제작사 로고
                                if (movieDetail
                                    .productionCompanyLogos.isNotEmpty)
                                  _buildProductionCompanies(
                                      context, movieDetail),
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

// 헬퍼 위젯: 제목
  Widget _buildHeader(BuildContext context, MovieDetail movieDetail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            movieDetail.title,
            style: TextStyle(
                fontSize: context.sw * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            DateFormat('yyyy.MM.dd').format(movieDetail.releaseDate),
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }

// 헬퍼 위젯: 테그라인
  Widget _buildTagline(BuildContext context, MovieDetail movieDetail) {
    return Text(
      '${movieDetail.tagline}',
      style: const TextStyle(
          fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
    );
  }

  // 헬퍼 위젯: 런타임
  Widget _buildRuntime(BuildContext context, MovieDetail movieDetail) {
    return Text(
      '${movieDetail.runtime}분',
      style: const TextStyle(color: Colors.grey),
    );
  }

// 헬퍼 위젯: 장르
  Widget _buildGenreTags(BuildContext context, MovieDetail movieDetail) {
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movieDetail.genres.length,
        itemBuilder: (context, index) {
          final genre = movieDetail.genres[index];
          return InkWell(
            onTap: () {
              final encodedGenreName = Uri.encodeComponent(genre.name);
              context.push('/genre/${genre.id}', extra: encodedGenreName);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: EdgeInsets.only(right: 8.0),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              decoration: BoxDecoration(
                // color: Colors.white,
                border: Border.all(
                    color: context.colors.mistyLavender!, width: 1.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                genre.name,
                style: TextStyle(
                    color: context.colors.mistyLavender,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto'),
              ),
            ),
          );
        },
      ),
    );
  }

// 헬퍼 위젯: 흥행정보
  Widget _buildBoxOfficeInfo(BuildContext context, MovieDetail movieDetail) {
    final numberFormat = NumberFormat.decimalPattern('en_US');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoldenText('흥행정보', fontSize: 18),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _infoBox('⭐ 평점', movieDetail.voteAverage.toStringAsFixed(1)),
              _infoBox('평점투표수', numberFormat.format(movieDetail.voteCount)),
              _infoBox('인기점수', movieDetail.popularity.toStringAsFixed(0)),
              if (movieDetail.budget > 0)
                _infoBox('예산', '\$${numberFormat.format(movieDetail.budget)}'),
              if (movieDetail.revenue > 0)
                _infoBox('수익', '\$${numberFormat.format(movieDetail.revenue)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoBox(String title, String value) {
    return IntrinsicWidth(
      child: Container(
        constraints: BoxConstraints(
          minWidth: 110, // 최소 너비만 지정해서 기본 크기 유지
        ),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // color: context.colors.royalDeepPurple?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                    color: Colors.grey, fontSize: 14, fontFamily: 'Roboto')),
            // const Spacer(),
            SizedBox(height: 5),
            Flexible(
              child: Text(value,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto')),
            ),
          ],
        ),
      ),
    );
  }

// 헬퍼 위젯: 후원사
  Widget _buildProductionCompanies(
      BuildContext context, MovieDetail movieDetail) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movieDetail.productionCompanyLogos.length,
        itemBuilder: (context, index) {
          final logoPath = movieDetail.productionCompanyLogos[index];
          return (logoPath == null || logoPath.isEmpty)
              ? const SizedBox.shrink() // logoPath가 없으면 빈 공간을 반환
              : Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Image.network(
                        'https://image.tmdb.org/t/p/w200$logoPath'),
                  ),
                );
        },
      ),
    );
  }

  // 헬퍼위젯: 구분선
  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 1.0,
      color: context.colors.silverMist, // 은색 구분선
      margin: const EdgeInsets.symmetric(horizontal: 0),
    );
  }
}
