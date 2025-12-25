import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/data/hips/hips_detail.dart';

class HipsCard extends ConsumerWidget {
  final HipsDetail hipsDetail;

  const HipsCard({super.key, required this.hipsDetail});

  Widget _content(BuildContext context, WidgetRef ref) {
    final title = hipsDetail.title;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        IconButton(
            onPressed: () {
              // TODO : Ajouter le HiPS aux favoris
            },
            icon: Icon(
              Icons.star_border,
              color: Colors.amber,
            ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // TODO : Ouvrir les infos d'un HiPS
      },

      child: Card(
        color: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: _content(context, ref)
        ),
      ),
    );
  }
}