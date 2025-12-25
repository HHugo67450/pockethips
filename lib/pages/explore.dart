import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/notifiers/filters/filters_notifier.dart';
import 'package:pocket_hips/notifiers/hips/hips_total_notifier.dart';
import 'package:pocket_hips/widgets/hips/hips_total_display.dart';

import '../widgets/filters/filters_burger_menu.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});

  @override
  ConsumerState<Explore> createState() => _ExploreState();
}

class _ExploreState extends ConsumerState<Explore> {

  @override
  Widget build(BuildContext context) {
    final filtersState = ref.watch(filtersProvider);
    final filtersNotifier = ref.watch(filtersProvider.notifier);
    final hipsTotalAsync = ref.watch(hipsTotalProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading:
          IconButton(
              onPressed: () {
                filtersNotifier.toggleFilters();
              },
              icon: Icon(
                filtersState.showFilters ? Icons.expand_less : Icons.menu,
                color: Colors.white,
              ),
          ),

        title:
          const Text(
            "Explore & Filter",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
      ),

      body:
        CustomScrollView(
          slivers: [
            if (filtersState.showFilters) ...[
              const SliverToBoxAdapter(child:
                FiltersBurgerMenu()
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider(color: Colors.grey[800]),
                ),
              ),
            ],

            HipsTotalDisplay(hipsTotalAsync: hipsTotalAsync),

            const SliverFillRemaining(),
          ],
        ),
    );
  }
}
