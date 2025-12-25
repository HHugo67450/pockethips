import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/widgets/hips/hips_card.dart';

import '../../notifiers/hips/hips_list_notifier.dart';

class HipsList extends ConsumerWidget {
  const HipsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hipsListAsync = ref.watch(hipsListProvider);

    return hipsListAsync.when(
      data: (hipsDetails) {
        return ListView.builder(
          itemCount: hipsDetails.length,
          itemBuilder: (context, index) {
            final hipsDetail = hipsDetails[index];
            return HipsCard(hipsDetail: hipsDetail);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error while loading HiPS details')),
    );
  }
}