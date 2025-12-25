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
        '[HipsRepository][ERROR] Exception while fetching HIPS registry\n$e\n$st',
      );
      rethrow;
    }
  }

  Future<int?> getHipsTotal(String providerUrl) async {
    const url = 'https://alasky.cds.unistra.fr/MocServer/query';
    final queryParameters = <String, String> {
      'hips_service_url': replaceUrlWithWildcards(providerUrl),
      'get': 'number',
      'fmt': 'json',
    };

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
        '[HipsRepository][ERROR] Exception while fetching HIPS total\n$e\n$st',
      );
      rethrow;
    }
  }

  Future<List<HipsDetail>> getHipsDetail(String providerUrl) async {
    const url = 'https://alasky.cds.unistra.fr/MocServer/query';
    final queryParameters = <String, String> {
      'hips_service_url': replaceUrlWithWildcards(providerUrl),
      'get': 'record',
      'fmt': 'json',
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return json.map((json) => HipsDetail.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get hips detail');
      }
    } catch (e, st) {
      debugPrint(
        '[HipsRepository][ERROR] Exception while fetching HIPS detail\n$e\n$st',
      );
      rethrow;
    }
  }
}

String replaceUrlWithWildcards(String url) {
  final uri = Uri.parse(url);
  return '*${uri.host}*';
}

final hipsRepositoryProvider = Provider((ref) => HipsRepository());