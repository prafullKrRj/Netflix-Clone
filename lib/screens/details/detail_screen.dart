import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netflix_clone/data/repository.dart';

class MovieDetailScreen extends ConsumerWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie = ref.watch(currentMovieProvider);
    if (movie == null) {
      return const Scaffold(
        body: Text("Unable to load"),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: movie.imageUrl != null
                  ? Image.network(
                      movie.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : const Center(child: Icon(Icons.movie, size: 100)),
              title: Text(movie.name),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Row(
                    children: [
                      if (movie.rating != null)
                        Chip(
                          avatar: const Icon(Icons.star, color: Colors.amber),
                          label: Text(movie.rating!.toString()),
                        ),
                      const SizedBox(width: 8),
                      if (movie.status != null)
                        Chip(
                          label: Text(movie.status!),
                          backgroundColor: movie.status == 'Ended'
                              ? Colors.red.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Genre Tags
                  if (movie.genres?.isNotEmpty ?? false)
                    Wrap(
                      spacing: 8,
                      children: movie.genres!
                          .map((genre) => Chip(label: Text(genre)))
                          .toList(),
                    ),
                  const SizedBox(height: 24),

                  // Info Section
                  Text('About',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    movie.summary.replaceAll(RegExp(r'<[^>]*>'), ''),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Details Section
                  Text('Details',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  _DetailItem(
                    icon: Icons.language,
                    label: 'Language',
                    value: movie.language,
                  ),
                  if (movie.runtime != null)
                    _DetailItem(
                      icon: Icons.timer,
                      label: 'Runtime',
                      value: '${movie.runtime} minutes',
                    ),
                  if (movie.premiered != null)
                    _DetailItem(
                      icon: Icons.calendar_today,
                      label: 'Premiered',
                      value: movie.premiered!,
                    ),
                  if (movie.network != null)
                    _DetailItem(
                      icon: Icons.tv,
                      label: 'Network',
                      value:
                          '${movie.network!.name} (${movie.network!.countryCode})',
                    ),
                  if (movie.schedule != null)
                    _DetailItem(
                      icon: Icons.schedule,
                      label: 'Schedule',
                      value:
                          '${movie.schedule!.time} on ${movie.schedule!.days.join(", ")}',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: movie.officialSite != null
          ? FloatingActionButton.extended(
              onPressed: () => launchUrl(Uri.parse(movie.officialSite!)),
              label: const Text('Visit Website'),
              icon: const Icon(Icons.language),
            )
          : null,
    );
  }

  void launchUrl(Uri uri) {}
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
