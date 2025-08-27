import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tudum_kingdom/presentation/providers.dart';

class GenreMovieScreen extends ConsumerWidget {
  final int genreId;
  final String genreName;

  const GenreMovieScreen(
      {super.key, required this.genreId, required this.genreName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(genreMovieViewModelProvider(genreId));

    return Scaffold(
      appBar: AppBar(title: Text(Uri.decodeComponent(genreName))),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2 / 3, // 포스터 비율
              ),
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return GestureDetector(
                  onTap: () => context.push('/detail/${movie.id}', extra: {
                    'movie': movie,
                    'tagHeader': 'genre_${genreId}_'
                  }),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                      fit: BoxFit.cover,
                      // 이미지를 불러오는 동안 보여줄 임시 UI
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[850]),
                      // 에러 발생 시 보여줄 UI
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
