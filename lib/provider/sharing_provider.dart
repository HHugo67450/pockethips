import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

final sharingProvider = Provider<SharingService>((ref) {
  return SharingService();
});

class SharingService {
  Future<ShareResult> share({
    required String text,
    String? subject,
    String? title,
  }) async {
    final params = ShareParams(
      text: text,
      subject: subject,
      title: title,
    );
    return await SharePlus.instance.share(params);
  }

  Future<ShareResult> shareFiles({
    required List<XFile> files,
    String? text,
    String? subject,
    String? title,
  }) async {
    final params = ShareParams(
      text: text,
      subject: subject,
      title: title,
      files: files,
    );
    return await SharePlus.instance.share(params);
  }
}
