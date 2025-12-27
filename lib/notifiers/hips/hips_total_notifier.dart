import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'hips_list_notifier.dart';


class HipsTotalNotifier extends AsyncNotifier<int> {

  @override
  FutureOr<int> build() async {
    final filteredHipsListAsync = ref.watch(filteredHipsListProvider);

    return filteredHipsListAsync.when(
      data: (hipsDetails) => hipsDetails.length,
      loading: () => 0,
      error: (e, st) => 0,
    );
  }
}

final hipsTotalProvider = AsyncNotifierProvider<HipsTotalNotifier, int>(
  HipsTotalNotifier.new,
);