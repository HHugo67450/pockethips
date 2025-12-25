import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/hips/hips_registry.dart';

class HipsRepository {

  Future<List<HipsRegistry>> getHipsRegistries() async {
    const registryUrl = 'https://aladin.cds.unistra.fr/hips/registry';
    final uri = Uri.parse(registryUrl);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return HipsRegistry.fromText(response.body);
      } else {
        throw Exception('Failed to load hips registries');
      }
    } catch (e, st) {
      debugPrint(
        '[HipsRepository][ERROR] Exception while fetching HIPS registry\n$e\n$st',
      );
      rethrow;
    }
  }
}

final hipsRepositoryProvider = Provider((ref) => HipsRepository());