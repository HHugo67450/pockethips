import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/notifiers/filters/filters_notifier.dart';

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
          )
      ),
    );
  }
}