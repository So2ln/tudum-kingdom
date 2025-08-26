import 'package:go_router/go_router.dart';
import 'package:tudum_kingdom/domain/entity/movie.dart';
import 'package:tudum_kingdom/presentation/detail/detail_screen.dart';
import 'package:tudum_kingdom/presentation/home/home_screen.dart';

final router = GoRouter(routes: [
  // 1. 홈화면 경로
  GoRoute(
    path: '/',
    builder: (context, state) => const HomeScreen(),
  ),

  // 2. 디테일 화면 경로
  GoRoute(
    path: 'detail/:movieId',
    builder: (context, state) {
      final movie = state.extra as Movie;

      return DetailScreen(movie: movie);
    },
  )
]);
