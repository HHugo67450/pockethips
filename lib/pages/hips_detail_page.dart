import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/provider/url_launcher_provider.dart';

import '../data/hips/hips_detail.dart';
import '../notifiers/hips/hips_detail_notifier.dart';
import '../notifiers/hips/hips_image_url_notifier.dart';
import '../utils/date_utils.dart';
import '../provider/sharing_provider.dart';

class HipsDetailPage extends ConsumerWidget {
  final HipsDetail initialHipsDetail;

  const HipsDetailPage({super.key, required this.initialHipsDetail});

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

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref, HipsDetail hipsDetail) {
    return AppBar(
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
    );
  }

  Widget _buildHipsImageStack(BuildContext context, WidgetRef ref,
      HipsDetail hipsDetail, AsyncValue<String> imageUrlAsync,
      ScaffoldMessengerState scaffoldMessenger) {
    return Stack(
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
              child: Center(child: Icon(
                  Icons.error,
                  color: Colors.grey,
                  size: 50
              )),
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
                      child: Center(child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 50
                      )),
                    );
                  },
                ),
              );
            }
            return const SizedBox(
              width: double.infinity,
              height: 250,
              child: Center(child: Icon(Icons.image_not_supported,
                  color: Colors.grey, size: 50)),
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: ElevatedButton.icon(
            onPressed: () async {
              final notifier = ref.read(hipsDetailNotifierProvider(initialHipsDetail).notifier);
              await notifier.loadRandomHips().catchError((e) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Failed to load random HiPS.'),
                  ),
                );
              });
            },
            icon: const Icon(Icons.shuffle, color: Colors.white),
            label: const Text('Random', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(HipsDetail hipsDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildDetailsSection(HipsDetail hipsDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Details'),
        _buildDetailRow('Observatory', hipsDetail.observatory.isNotEmpty ? hipsDetail.observatory : 'N/A'),
        _buildDetailRow('Collection', hipsDetail.collection.isNotEmpty ? hipsDetail.collection : 'N/A'),
        _buildDetailRow('Epoch', formatMjdRange(hipsDetail.tMin, hipsDetail.tMax)),
      ],
    );
  }

  Widget _buildSourceWebsiteButton(BuildContext context, WidgetRef ref,
      HipsDetail hipsDetail, ScaffoldMessengerState scaffoldMessenger) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextButton(
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
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hipsDetailAsync = ref.watch(hipsDetailNotifierProvider(initialHipsDetail));

    return hipsDetailAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF0D1117),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: const Color(0xFF0D1117),
        body: Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))), 
      ),
      data: (hipsDetail) {
        final imageUrlAsync = ref.watch(hipsImageUrlProvider(hipsDetail));
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        return Scaffold(
          backgroundColor: const Color(0xFF0D1117),
          appBar: _buildAppBar(context, ref, hipsDetail),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHipsImageStack(context, ref, hipsDetail, imageUrlAsync, scaffoldMessenger),
                  const SizedBox(height: 24),
                  _buildDescriptionSection(hipsDetail),
                  const SizedBox(height: 24),
                  _buildDetailsSection(hipsDetail),
                  _buildSourceWebsiteButton(context, ref, hipsDetail, scaffoldMessenger),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
