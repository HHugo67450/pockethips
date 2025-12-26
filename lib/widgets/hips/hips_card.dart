import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/data/hips/hips_detail.dart';
import 'package:pocket_hips/notifiers/filters/favorites_notifier.dart';
import 'package:pocket_hips/pages/hips_detail_page.dart';

import '../../notifiers/hips/hips_image_url_notifier.dart';

class HipsCard extends ConsumerWidget {
  final HipsDetail hipsDetail;

  const HipsCard({super.key, required this.hipsDetail});

  Widget _hipsPreview(BuildContext context, WidgetRef ref) {
    final imageUrlAsync = ref.watch(hipsImageUrlProvider(hipsDetail));

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: SizedBox(
        width: 96,
        height: 96,
        child: imageUrlAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Icon(Icons.broken_image, color: Colors.red),
          ),

          data: (imageUrl) {
            if (imageUrl.isNotEmpty) {
              return Image.network(
                imageUrl,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (_, __, ___) {
                  return const Center(child: Icon(Icons.image_not_supported, color: Colors.red));
                },
              );
            }
            return const Center(child: Icon(Icons.image_not_supported, color: Colors.grey));
          },
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Chip(
      label: Text(
        text,
        overflow: TextOverflow.ellipsis,
      ),
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
      backgroundColor: const Color(0xFF21262D),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref) {
    final title = hipsDetail.title;
    final provider = hipsDetail.provider;
    final isFavorite = ref.watch(favoritesProvider.select(
        (favorites) => favorites.contains(hipsDetail.id),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _hipsPreview(context, ref),

        const SizedBox(width: 12),

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

              const SizedBox(height: 6),

              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _chip(provider),
                  const SizedBox(),
                  if (hipsDetail.contentType.isNotEmpty)
                    _chip(hipsDetail.contentType),
                  const SizedBox(),
                  if (hipsDetail.color.isNotEmpty)
                    _chip(hipsDetail.color)
                ],
              ),
            ],
          ),
        ),

        IconButton(
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggleFavorite(hipsDetail);
            },
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HipsDetailPage(hipsDetail: hipsDetail),
          ),
        );
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
