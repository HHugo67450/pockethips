import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/widgets/filters/filter_color.dart';
import 'package:pocket_hips/widgets/filters/filter_content.dart';
import 'package:pocket_hips/widgets/filters/filter_favorites.dart';
import 'package:pocket_hips/widgets/filters/filter_year_range.dart';

import 'filter_registries.dart';

class FiltersBurgerMenu extends ConsumerWidget {
  const FiltersBurgerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF161B22),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FilterFavorites(),
          const SizedBox(height: 15),
          const FilterRegistries(),
          const SizedBox(height: 15),
          const FilterContent(),
          const SizedBox(height: 15),
          const FilterColor(),
          const SizedBox(height: 15),
          const FilterYearRange(),
        ],
      ),
    );
  }
}