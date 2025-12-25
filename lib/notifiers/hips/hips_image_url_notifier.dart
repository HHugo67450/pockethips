import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_hips/data/hips/hips_detail.dart';
import 'package:pocket_hips/repository/hips_repository.dart';

final hipsImageUrlProvider = FutureProvider.family<String, HipsDetail>((ref, hipsDetail) async {
  final hipsRepository = ref.watch(hipsRepositoryProvider);
  return hipsRepository.getHipsImageUrl(hipsDetail);
});
