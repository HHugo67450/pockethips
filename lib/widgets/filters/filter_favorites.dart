import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/filters/filters_notifier.dart';

class FilterFavorites extends ConsumerWidget {
  const FilterFavorites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favoritesOnly = ref.watch(filtersProvider.select(
        (state) => state.favoritesOnly));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Show Favorites Only',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Filter by your saved items',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Switch(
          value: favoritesOnly,
          onChanged: (_) {
            ref.read(filtersProvider.notifier).toggleFavoritesOnly();
          },
          activeThumbColor: const Color(0xFF007AFF),
          activeTrackColor: const Color(0xFF34C759).withValues(alpha: 0.5),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.withValues(alpha: 0.5),
        )
      ],
    );
  }
}