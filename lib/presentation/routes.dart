import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/presentation/detail/detail_screen.dart';
import 'package:tudum_kingdom/presentation/genre/genre_movie_screen.dart';
import 'package:tudum_kingdom/presentation/home/home_screen.dart';
import 'package:tudum_kingdom/presentation/invitation/invitation_screen.dart';
import 'package:tudum_kingdom/presentation/splash/splash_screen.dart';

final router = GoRouter(initialLocation: '/splash', routes: [
  // 0. 스플래시 화면 추가
  GoRoute(
    path: '/splash',
    builder: (context, state) => const SplashScreen(),
  ),

  // 1. 홈화면 경로
  GoRoute(
    path: '/',
    builder: (context, state) => HomeScreen(),
  ),

  // 2. 디테일 화면 경로
  GoRoute(
    path: '/detail/:movieId',
    builder: (context, state) {
      final data = state.extra as Map<String, dynamic>;

      return DetailScreen(movie: data['movie'], tagHeader: data['tagHeader']);
    },
  ),

  // 초대장 페이지를 위한 새로운 경로 추가
  GoRoute(
    path: '/invitation',
    // PageRouteBuilder를 사용해서 커스텀 페이지 전환 효과를 만듬
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        child: const InvitationScreen(),
        // false로 설정해야 아래 깔린 홈 화면이 비쳐 보인다
        opaque: false,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // FadeTransition으로 부드럽게 나타나는 효과
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  ),

  GoRoute(
    path: '/genre/:genreId',
    builder: (context, state) {
      final genreId = int.parse(state.pathParameters['genreId']!);
      final genreName = state.extra as String; // extra로 장르 이름을 받아요.
      return GenreMovieScreen(genreId: genreId, genreName: genreName);
    },
  ),
]);
