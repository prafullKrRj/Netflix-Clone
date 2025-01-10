import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netflix_clone/model/movie.dart';

import '../../data/repository.dart';
import '../commons/movie_card.dart';

final hasSearchedProvider = StateProvider<bool>((ref) => false);

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultProvider = FutureProvider.autoDispose<List<Movie>>((ref) {
  final hasSearched = ref.watch(hasSearchedProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  if (hasSearched && searchQuery.isNotEmpty) {
    final userRepository = ref.watch(userRepositoryProvider);
    return userRepository.searchMovies(searchQuery);
  }
  return Future.value([]);
});

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSearched = ref.watch(hasSearchedProvider.notifier);
    final searchResult = ref.watch(searchResultProvider);
    final searchQuery = ref.watch(searchQueryProvider.notifier);
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Search Movies',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Custom Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: controller,
                        onSubmitted: (value) {
                          hasSearched.state = true;
                          searchQuery.state = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Search for movies...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    controller.clear();
                                    hasSearched.state = false;
                                    searchQuery.state = '';
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (controller.text.isEmpty)
                      // Popular Searches (when no search is active)
                      const Text(
                        'Please search for your favorite movies',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (controller.text.isNotEmpty && hasSearched.state)
                      // Search Results Grid
                      searchResult.when(
                        data: (movies) {
                          if (movies.isEmpty) {
                            return const Text('No results found');
                          }
                          return SliverPadding(
                            padding: const EdgeInsets.all(16.0),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final movie = movies[index];
                                  return MovieCard(movie: movie);
                                },
                                childCount: movies.length,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.8,
                              ),
                            ),
                          );
                        },
                        loading: () => const MovieLoadingScreen(),
                        error: (error, stackTrace) {
                          return Text('Error: $error');
                        },
                      ),
                  ],
                ),
              ),
            ),
            // Popular Searches (when no search is active)

            // Search Results Grid
          ],
        ),
      ),
    );
  }
}

class MovieLoadingScreen extends StatelessWidget {
  const MovieLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Placeholder grid items
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.movie,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  // Placeholder Text
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          color: Colors.grey[200],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 100,
                          color: Colors.grey[200],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: 6, // Number of placeholder items
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
      ),
    );
  }
}
