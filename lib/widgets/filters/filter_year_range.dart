import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/filters/filters_notifier.dart';

class FilterYearRange extends ConsumerWidget {
  const FilterYearRange({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearRange = ref.watch(filtersProvider.select(
            (state) => state.yearRange));
    if (yearRange == null) {
      return const SizedBox.shrink();
    }

    final filters = ref.read(filtersProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Year Range',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 8),

        RangeSlider(
          values: yearRange,
          min: filters.minYear,
          max: filters.maxYear,
          divisions: (filters.maxYear - filters.minYear).toInt(),
          labels: RangeLabels(
            yearRange.start.round().toString(),
            yearRange.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            ref.read(filtersProvider.notifier).setYearRange(values);
          },
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text('Start: \${yearRange.start.round()}')),
            Flexible(child: Text('End: \${yearRange.end.round()}')),
          ],
        ),
      ],
    );
  }
}