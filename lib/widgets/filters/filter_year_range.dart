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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'YEAR RANGE',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF21262D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${yearRange.start.round()} - ${yearRange.end.round()}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.white24,
            thumbColor: Colors.blue,
            overlayColor: Colors.blue.withValues(alpha: 0.2),
            trackHeight: 2.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 8.0),
          ),
          child: RangeSlider(
            values: yearRange,
            min: filters.minYear,
            max: filters.maxYear,
            divisions: (filters.maxYear - filters.minYear).toInt(),
            onChanged: (RangeValues values) {
              ref.read(filtersProvider.notifier).setYearRange(values);
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                filters.minYear.round().toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                filters.maxYear.round().toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}