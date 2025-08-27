import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/presentation/providers.dart';
import 'package:tudum_kingdom/presentation/theme/build_context_ext.dart';
import 'package:tudum_kingdom/presentation/widgets/golden_text.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // 배너 넣으려구용 "공주는 영화가 보고싶어"
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  static const int _bannerPageCount = 2;

  // 인기 영화 리스트를 위한 스크롤 컨트롤러 선언
  final ScrollController _popularScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoScroll();
    // 스크롤 리스너 추가
    _popularScrollController.addListener(() {
      // 스크롤이 맨 끝에 도달했을 때
      if (_popularScrollController.position.pixels >=
          _popularScrollController.position.maxScrollExtent - 10) {
        // 맨 끝 10px 전에 미리 로드!
        // ViewModel에 추가 데이터 요청
        ref.read(homeViewModelProvider.notifier).fetchMorePopularMovies();
      }
    });
  }

  void _startAutoScroll() {
    // 3초마다 자동으로 페이지 넘기기
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;

      int nextPage = (_currentPage + 1) % _bannerPageCount;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // 화면이 사라질 때 Timer와 컨트롤러를 꼭! 제거해야 메모리 누수를 막을 수 있다.
    _timer?.cancel();
    _pageController.dispose();
    _popularScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);

    if (homeState.isLoading) {
      return Scaffold(
        backgroundColor: context.colors.deepPurpleNight,
        body: Center(
            child:
                CircularProgressIndicator(color: context.colors.mistyLavender)),
      );
    }

    return Scaffold(
      backgroundColor: context.colors.deepPurpleNight,
      body: SafeArea(
        // 무한스크롤을 위해 기존 ui를 refresh indicator로 감싸줌
        child: RefreshIndicator(
          color: context.colors.mistyLavender,
          // 로딩 아이콘 두께를 좀만 더 두껍게 (기본값은 2.0)
          strokeWidth: 3.0,
          // 아이콘이 나타나는 위치를 아래로 좀 더 내려서 잘 보이게
          displacement: 40.0,

          onRefresh: () async {
            // ViewModel의 refresh 메소드를 호출
            // '.notifier'를 통해 메소드에 접근하고, read를 사용해 단 한번만 호출한다
            await ref.read(homeViewModelProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.sh * 0.02),

                // 섹션 1: 가장 인기있는 영화 이미지 (배너)
                if (homeState.popularMovies.isNotEmpty)
                  _buildChoiceBanner(context,
                      homeState.popularMovies.first), // 다시 왕큰 배너 메소드 사용!

                SizedBox(height: context.sh * 0.03),
                // 섹션 2: 현재 상영중 (가로 리스트)
                _buildMovieListSection(
                  context: context,
                  title: '왕국의 최신 상영작 🎬',
                  movies: homeState.nowPlayingMovies,
                  tagHeader: 'now_playing',
                ),

                // 섹션 3: 인기순 (가로 리스트 + 랭킹)
                _buildMovieListSection(
                  context: context,
                  title: '명예의 전당: 인기 영화 ✨',
                  movies: homeState.popularMovies,
                  showRank: true, // 인기순 목록에만 랭킹 표시
                  tagHeader: 'popularity',
                  scrollController: _popularScrollController,
                ),

                // 섹션 4: 평점 높은 순 (가로 리스트)
                _buildMovieListSection(
                  context: context,
                  title: '백성들의 뜨거운 찬사 🌟',
                  movies: homeState.topRatedMovies,
                  tagHeader: 'top_rated',
                ),

                // 섹션 5: 개봉 예정 (가로 리스트)
                _buildMovieListSection(
                  context: context,
                  title: '개봉을 앞둔 비밀의 화원 🌷',
                  movies: homeState.upcomingMovies,
                  tagHeader: 'upcoming',
                ),

                SizedBox(height: context.sh * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceBanner(BuildContext context, Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.sw * 0.05, vertical: 8.0),
          child: GoldenText(
            "움바 공주's Choice 👑",
            fontSize: 22,
          ),
        ),
        SizedBox(
          height: context.sh * 0.4,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _bannerPageCount,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              Widget pageItem;
              if (index == 0) {
                pageItem = GestureDetector(
                  onTap: () => context.push('/invitation'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.asset('assets/images/dark_logo.png',
                        fit: BoxFit.contain),
                  ),
                );
              } else {
                pageItem = GestureDetector(
                  // context.go 대신 push로 변경해서 뒤로가기를 누를 수 있게 해주기!
                  onTap: () => context.push('/detail/${movie.id}',
                      extra: {'movie': movie, 'tagHeader': 'choice'}),
                  child: Hero(
                    tag: 'choice_${movie.id}',
                    child: Image.network(
                        'https://image.tmdb.org/t/p/w780${movie.posterPath}',
                        fit: BoxFit.contain),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16), child: pageItem),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerPageCount, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
              width: _currentPage == index ? 12.0 : 8.0,
              height: _currentPage == index ? 12.0 : 8.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? context.colors.crownGold
                    : Colors.grey[50],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMovieListSection({
    required BuildContext context,
    required String title,
    required List<Movie> movies,
    bool showRank = false,
    required String tagHeader,
    bool hasLeadingAd = false,
    ScrollController? scrollController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: GoldenText(
            title,
            fontSize: 22,
          ),
        ),
        SizedBox(
          height: context.sh * 0.22,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: (hasLeadingAd ? 1 : 0) + movies.length,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (context, index) {
              // 첫 번째일 경우 로고 이미지를 보여주는 로직!
              if (hasLeadingAd && index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      width: 120, // 다른 포스터와 비슷한 너비로
                    ),
                  ),
                );
              }

              // 배너 다음부터는 영화 목록을 보여줌
              final movieIndex = hasLeadingAd ? index - 1 : index;
              final movie = movies[movieIndex];

              return _buildMovieListItem(
                tagHeader: tagHeader,
                context: context,
                movie: movie,
                rank: index + 1,
                showRank: showRank,
              );
            },
          ),
        ),
        SizedBox(height: context.sh * 0.02),
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
        onTap: () => context.push(
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
                  'https://image.tmdb.org/t/p/w300${movie.posterPath}',
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
