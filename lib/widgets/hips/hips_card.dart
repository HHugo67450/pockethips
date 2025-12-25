import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/data/hips/hips_detail.dart';

class HipsCard extends ConsumerWidget {
  final HipsDetail hipsDetail;

  const HipsCard({super.key, required this.hipsDetail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hipsDetail.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // Add more details here if needed
          ],
        ),
      ),
    );
  }
}