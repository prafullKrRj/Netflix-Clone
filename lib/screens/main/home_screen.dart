import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository.dart';
import '../../model/movie.dart';
import '../commons/movie_card.dart';

final fetchMovies = FutureProvider<List<Movie>>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getAllMovies();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(fetchMovies);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: movies.when(
        data: (data) {
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final movie = data[index];
              return MovieCard(
                movie: movie,
                onTap: () {
                  ref.read(currentMovieProvider.notifier).state = movie;
                  Navigator.pushNamed(context, '/details');
                },
              );
            },
          );
        },
        error: (error, stacktrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
