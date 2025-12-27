import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/notifiers/filters/filters_notifier.dart';
import 'package:pocket_hips/notifiers/hips/hips_total_notifier.dart';
import 'package:pocket_hips/widgets/hips/hips_list.dart';
import 'package:pocket_hips/widgets/hips/hips_total_display.dart';

import '../widgets/filters/filters_burger_menu.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});

  @override
  ConsumerState<Explore> createState() => _ExploreState();
}

class _ExploreState extends ConsumerState<Explore> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(filtersProvider.notifier).setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        leading: filtersState.isSearching
          ? IconButton(
            onPressed: () {
              filtersNotifier.toggleSearch();
              _searchController.text = "";
            },
            icon: const Icon(
                Icons.arrow_back,
                color: Colors.white
            ),
          )
          : IconButton(
              onPressed: () {
                filtersNotifier.toggleFilters();
              },
              icon: Icon(
                filtersState.showFilters ? Icons.expand_less : Icons.menu,
                color: Colors.white,
              ),
          ),

        title: filtersState.isSearching
          ? TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0
            ),
            decoration: const InputDecoration(
              hintText: 'Search by title...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          )
          : const Text(
            "Explore & Filter",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

        actions: [
          if (filtersState.isSearching)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.text = "";
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: filtersNotifier.toggleSearch,
            ),
        ],
      ),

      body: Column(
        children: [
          if (filtersState.showFilters) ...[
            const FiltersBurgerMenu(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Divider(color: Colors.grey[800]),
            ),
          ],
          Expanded(
            child: CustomScrollView(
              slivers: [
                HipsTotalDisplay(hipsTotalAsync: hipsTotalAsync),
                const SliverFillRemaining(child: HipsList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
