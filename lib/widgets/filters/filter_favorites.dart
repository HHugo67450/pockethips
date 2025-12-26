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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
        ),
      ),

      child: Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.white70,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
                'Favorites only',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Switch(
            value: favoritesOnly,
            onChanged: (_) {
              ref.read(filtersProvider.notifier).toggleFavoritesOnly();
            },
            activeThumbColor: Colors.amber,
          )
        ],
      ),
    );
  }
}