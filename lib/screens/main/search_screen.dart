import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netflix_clone/model/movie.dart';
import 'package:netflix_clone/screens/commons/movie_card.dart';

import '../../data/repository.dart';

final hasSearchedProvider = StateProvider<bool>((ref) => false);
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultProvider = FutureProvider.autoDispose<List<Movie>>((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  if (searchQuery.isNotEmpty) {
    final userRepository = ref.watch(userRepositoryProvider);
    return userRepository.searchMovies(searchQuery);
  }
  return Future.value([]);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final hasSearched = ref.watch(hasSearchedProvider.notifier);
    final searchQuery = ref.watch(searchQueryProvider.notifier);
    final searchResult = ref.watch(searchResultProvider);
    final TextEditingController controller =
        TextEditingController(text: searchQuery.state);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search Header
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
                          ref.refresh(searchResultProvider);
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
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            // Search Results
            searchResult.when(
              data: (movies) {
                if (movies.isEmpty && hasSearched.state) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No results found'),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final movie = movies[index];
                        return MovieCard(
                          movie: movie,
                          onTap: () {
                            ref.read(currentMovieProvider.notifier).state =
                                movie;
                            Navigator.pushNamed(context, '/details');
                          },
                        );
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
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
