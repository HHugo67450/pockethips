import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/hips/hips_detail.dart';
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
        '[HipsRepository][ERROR] Exception while fetching HIPS registry $e $st',
      );
      rethrow;
    }
  }

  Future<int?> getHipsTotal(String providerUrl,
      List<String> dataproductType, List<String> color) async {
    const url = 'https://alasky.cds.unistra.fr/MocServer/query';
    final queryParameters = <String, String> {
      'hips_service_url': replaceUrlWithWildcards(providerUrl),
      'get': 'number',
      'fmt': 'json',
    };

    if (dataproductType.isNotEmpty) {
      queryParameters['dataproduct_type'] =
          dataproductType.map((type) => '*$type*').join(',');
    }

    if (color.isNotEmpty) {
      queryParameters['dataproduct_subtype'] =
          color.map((c) => '*${c.toLowerCase()}*').join(',');
    }

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['number'];
      } else {
        throw Exception('Failed to get hips total');
      }
    } catch (e, st) {
      debugPrint(
        '[HipsRepository][ERROR] Exception while fetching HIPS total $e $st',
      );
      rethrow;
    }
  }

  Future<List<HipsDetail>> getHipsDetail(String providerUrl,
      String providerName, List<String> dataproductType,
      List<String> color) async {
    const url = 'https://alasky.cds.unistra.fr/MocServer/query';
    final queryParameters = <String, String> {
      'hips_service_url': replaceUrlWithWildcards(providerUrl),
      'get': 'record',
      'fmt': 'json',
    };

    if (dataproductType.isNotEmpty) {
      queryParameters['dataproduct_type'] = dataproductType.map((type) => '*$type*').join(',');
    }

    if (color.isNotEmpty) {
      queryParameters['dataproduct_subtype'] =
          color.map((c) => '*${c.toLowerCase()}*').join(',');
    }

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return json.map((js) => HipsDetail.fromJson(js, provider: providerName)).toList();
      } else {
        throw Exception('Failed to get hips detail');
      }
    } catch (e, st) {
      debugPrint(
        '[HipsRepository][ERROR] Exception while fetching HIPS detail $e $st',
      );
      rethrow;
    }
  }

  Future<String> getHipsImageUrl(HipsDetail hipsDetail) async {
    const baseUrl = 'https://alasky.cds.unistra.fr/hips-image-services/hips2fits';

    final ra = hipsDetail.defaultRa.clamp(0.0, 360.0);
    final dec = hipsDetail.defaultDec.clamp(-90.0, 90.0);
    final fov = hipsDetail.defaultFov.clamp(0.00001, 180.0);

    final params = {
      'hips': hipsDetail.id,
      'ra': ra.toString(),
      'dec': dec.toString(),
      'fov': fov.toString(),
      'width': '512',
      'height': '512',
      'projection': 'TAN',
      'coordsys': 'icrs',
      'rotation': '45',
      'format': 'jpg',
    };

    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final url = '$baseUrl?$query';

    return url;
  }

}

String replaceUrlWithWildcards(String url) {
  final uri = Uri.parse(url);
  return '*${uri.host}*';
}

final hipsRepositoryProvider = Provider((ref) => HipsRepository());