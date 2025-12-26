import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/filters/filters_notifier.dart';

class FilterColor extends ConsumerWidget {
  const FilterColor({super.key});

  static const _colorMap = ['monochrome', 'blue', 'red', 'color'];

  Widget _buildColorOption(String colorName, bool isSelected) {
    Widget content;

    switch (colorName) {
      case 'monochrome':
        content = Icon(
          Icons.brightness_2_outlined,
          color: isSelected ? Colors.white : Colors.white70,
          size: 20,
        );
        break;
      case 'blue':
        content = Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          ),
        );
        break;
      case 'red':
        content = Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          ),
        );
        break;
      case 'color':
        content = Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.red, Colors.blue, Colors.purple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            shape: BoxShape.circle,
            border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          ),
        );
        break;
      default:
        content = const SizedBox.shrink();
        break;
    }

    return Container(
      width: 40,
      height: 38,
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF21262D)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: content),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColors = ref.watch(
        filtersProvider.select((state) => state.colorSelected));

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _colorMap.map((colorName) {
            final isSelected = selectedColors.contains(colorName);
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(filtersProvider.notifier).toggleColor(colorName);
                },
                child: _buildColorOption(colorName, isSelected),
              ),
            );
          }).toList()
      ),
    );
  }
}