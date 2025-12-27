import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/hips/hips_detail.dart';
import '../../repository/hips_repository.dart';

class HipsDetailNotifier extends StateNotifier<AsyncValue<HipsDetail>> {
  final HipsRepository _hipsRepository;

  HipsDetailNotifier(HipsDetail initialHipsDetail, this._hipsRepository)
      : super(AsyncValue.data(initialHipsDetail));

  Future<void> loadRandomHips() async {
    state = const AsyncValue.loading();
    try {
      final newHipsDetail = await _hipsRepository.getRandomHips();
      state = AsyncValue.data(newHipsDetail);
    } catch (e, st) {
      debugPrint('[HipsDetailNotifier][ERROR] Error loading random HiPS: $e $st');
      state = AsyncValue.error(e, st);
    }
  }
}

final hipsDetailNotifierProvider =
    StateNotifierProvider.family<HipsDetailNotifier, AsyncValue<HipsDetail>, HipsDetail>(
        (ref, initialHipsDetail) {
  final hipsRepository = ref.watch(hipsRepositoryProvider);
  return HipsDetailNotifier(initialHipsDetail, hipsRepository);
});

final randomHipsDetailProvider = FutureProvider.autoDispose<HipsDetail>((ref) async {
  final hipsRepository = ref.watch(hipsRepositoryProvider);
  return hipsRepository.getRandomHips();
});