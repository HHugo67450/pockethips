import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/provider/url_launcher_provider.dart';

import '../data/hips/hips_detail.dart';
import '../notifiers/hips/hips_image_url_notifier.dart';
import '../utils/date_utils.dart';
import '../provider/sharing_provider.dart'; // Added import

class HipsDetailPage extends ConsumerWidget {
  final HipsDetail hipsDetail;

  const HipsDetailPage({super.key, required this.hipsDetail});

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrlAsync = ref.watch(hipsImageUrlProvider(hipsDetail));
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          hipsDetail.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              final sharingService = ref.read(sharingProvider);
              sharingService.share(
                text: 'Check out this amazing HiPS: ${hipsDetail.title}! '
                    'Learn more here: ${hipsDetail.serviceUrl}',
                subject: hipsDetail.title,
                title: 'Share HiPS',
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageUrlAsync.when(
                loading: () => const Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (err, stack) => const Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Center(child: Icon(Icons.error, color: Colors.grey, size: 50)),
                  ),
                ),
                data: (imageUrl) {
                  if (imageUrl.isNotEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            width: double.infinity,
                            height: 250,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            width: double.infinity,
                            height: 250,
                            child: Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 50)),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Center(child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50)),
                  );
                },
              ),

              _buildSectionTitle('Description'),
              Text(
                hipsDetail.description.isNotEmpty
                    ? hipsDetail.description
                    : "HiPS description not available",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              _buildSectionTitle('Details'),
              _buildDetailRow('Observatory', hipsDetail.observatory.isNotEmpty ? hipsDetail.observatory : 'N/A'),
              _buildDetailRow('Collection', hipsDetail.collection.isNotEmpty ? hipsDetail.collection : 'N/A'),
              _buildDetailRow('Epoch', formatMjdRange(hipsDetail.tMin, hipsDetail.tMax)),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  ref.read(launchUrlProvider)(hipsDetail.serviceUrl).catchError((_) {
                    scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Could not open the website.'),
                        ),
                    );
                  });
                },
                child: const Text(
                  'View Source Website',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
