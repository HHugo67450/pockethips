import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/filters/filters_notifier.dart';

class FilterContent extends ConsumerWidget {
  const FilterContent({super.key});

  static const _contentMap = ['Image', 'Catalog', 'Cube', 'Spec'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContents = ref.watch(
        filtersProvider.select((state) => state.contentType));

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF30363D)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _contentMap.map((content) {
          final isSelected = selectedContents.contains(content.toLowerCase());

          return Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(filtersProvider.notifier).toggleContentType(content);
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF21262D)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Center(
                    child: Text(
                      content,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
          );
        }).toList()
      ),
    );
  }
}