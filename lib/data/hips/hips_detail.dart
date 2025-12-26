class HipsDetail {
  final String id;
  final String title;
  final String collection;
  final String description;
  final String observatory;
  final String serviceUrl;
  final double defaultRa;
  final double defaultDec;
  final double defaultFov;
  final double tMin;
  final double tMax;
  final String provider;
  final String contentType;
  final String color;

  HipsDetail({
    required this.id,
    required this.title,
    required this.collection,
    required this.description,
    required this.observatory,
    required this.serviceUrl,
    required this.defaultRa,
    required this.defaultDec,
    required this.defaultFov,
    required this.tMin,
    required this.tMax,
    required this.provider,
    required this.contentType,
    required this.color,
  });

  HipsDetail copyWith({
    String? id,
    String? title,
    String? collection,
    String? description,
    String? observatory,
    String? serviceUrl,
    double? defaultRa,
    double? defaultDec,
    double? defaultFov,
    double? tMin,
    double? tMax,
    String? provider,
    String? contentType,
    String? color,
  }) {
    return HipsDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      collection: collection ?? this.collection,
      description: description ?? this.description,
      observatory: observatory ?? this.observatory,
      serviceUrl: serviceUrl ?? this.serviceUrl,
      defaultRa: defaultRa ?? this.defaultRa,
      defaultDec: defaultDec ?? this.defaultDec,
      defaultFov: defaultFov ?? this.defaultFov,
      tMin: tMin ?? this.tMin,
      tMax: tMax ?? this.tMax,
      provider: provider ?? this.provider,
      contentType: contentType ?? this.contentType,
      color: color ?? this.color,
    );
  }

  factory HipsDetail.fromJson(Map<String, dynamic> json, {required String provider}) {
    String parseString(dynamic value) {
      if (value is String) {
        return value;
      }
      if (value is List) {
        return value.join(' ');
      }
      return '';
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String && value.isNotEmpty) return double.tryParse(value) ?? 1.0;
      return 1.0;
    }

    return HipsDetail(
      id: parseString(json['ID']),
      title: parseString(json['obs_title']),
      collection: parseString(json['obs_collection']),
      description: parseString(json['obs_description']),
      observatory: parseString(json['obs_copyright']),
      serviceUrl: parseString(json['hips_service_url']),
      defaultRa: parseDouble(json['hips_initial_ra']),
      defaultDec: parseDouble(json['hips_initial_dec']),
      defaultFov: parseDouble(json['hips_initial_fov']),
      tMin: parseDouble(json['t_min']),
      tMax: parseDouble(json['t_max']),
      provider: provider,
      contentType: parseString(json['dataproduct_type']),
      color: parseString(json['dataproduct_subtype']),
    );
  }
}
