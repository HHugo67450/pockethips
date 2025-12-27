import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/hips/hips_detail.dart';
import '../data/hips/hips_registry.dart';
import '../utils/date_utils.dart';

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
      List<String> dataproductType, List<String> color,
      RangeValues yearRange) async {
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

    if (yearRange.start != 1950.0
        || yearRange.end != DateTime.now().year.toDouble()) {
      final startMjd = yearToMjd(yearRange.start);
      final endMjd = yearToMjd(yearRange.end);
      queryParameters['TIME'] = '$startMjd $endMjd';
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
      List<String> color, RangeValues yearRange) async {
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

    if (yearRange.start != 1950.0
        || yearRange.end != DateTime.now().year.toDouble()) {
      final startMjd = yearToMjd(yearRange.start);
      final endMjd = yearToMjd(yearRange.end);
      queryParameters['TIME'] = '$startMjd $endMjd';
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

  Future<HipsDetail> getRandomHips() async {
    final registries = await getHipsRegistries();

    if (registries.isEmpty) {
      throw Exception('No HIPS registries found');
    }

    final uniqueProviders = <String, HipsRegistry>{};
    for (final reg in registries) {
      if (!uniqueProviders.containsKey(reg.provider)) {
        uniqueProviders[reg.provider] = reg;
      }
    }

    final Map<HipsRegistry, int> providerTotals = {};
    int totalHipsAcrossAllProviders = 0;

    for (final registry in uniqueProviders.values) {
      try {
        final total = await getHipsTotal(
          registry.url,
          [],
          [],
          RangeValues(1950.0, DateTime.now().year.toDouble()),
        );
        if (total != null && total > 0) {
          providerTotals[registry] = total;
          totalHipsAcrossAllProviders += total;
        }
      } catch (e, st) {
        debugPrint(
          '[HipsRepository][ERROR] Exception while fetching HIPS total for provider ${registry.provider}: $e $st',
        );
      }
    }

    if (providerTotals.isEmpty || totalHipsAcrossAllProviders == 0) {
      throw Exception('No HIPS found across any providers');
    }

    final random = Random();
    int randomWeight = random.nextInt(totalHipsAcrossAllProviders);

    HipsRegistry? selectedRegistry;
    for (final entry in providerTotals.entries) {
      randomWeight -= entry.value;
      if (randomWeight < 0) {
        selectedRegistry = entry.key;
        break;
      }
    }

    if (selectedRegistry == null) {
      throw Exception('Failed to select a random registry');
    }

    final hipsDetails = await getHipsDetail(
      selectedRegistry.url,
      selectedRegistry.provider,
      [],
      [],
      RangeValues(1950.0, DateTime.now().year.toDouble()),
    );

    if (hipsDetails.isEmpty) {
      throw Exception('No HIPS details found for selected registry: ${selectedRegistry.provider}');
    }

    return hipsDetails[random.nextInt(hipsDetails.length)];
  }
}

String replaceUrlWithWildcards(String url) {
  final uri = Uri.parse(url);
  return '*${uri.host}*';
}

final hipsRepositoryProvider = Provider((ref) => HipsRepository());