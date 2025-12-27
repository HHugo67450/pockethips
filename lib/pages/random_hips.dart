import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/hips/hips_detail_notifier.dart';
import 'hips_detail_page.dart';

class RandomHips extends ConsumerWidget {
  const RandomHips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomHipsDetailAsync = ref.watch(randomHipsDetailProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: randomHipsDetailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: \$err', style: const TextStyle(color: Colors.white)),
        ),
        data: (hipsDetail) => HipsDetailPage(initialHipsDetail: hipsDetail),
      ),
    );
  }
}
