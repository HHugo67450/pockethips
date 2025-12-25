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
    );
  }

  factory HipsDetail.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String && value.isNotEmpty) return double.tryParse(value) ?? 1.0;
      return 1.0;
    }

    return HipsDetail(
      id: json['ID'] ?? '',
      title: json['obs_title'] ?? '',
      collection: json['obs_collection'] ?? '',
      description: json['obs_description'] ?? '',
      observatory: json['obs_copyright'] ?? '',
      serviceUrl: json['hips_service_url'] ?? '',
      defaultRa: parseDouble(json['hips_initial_ra']),
      defaultDec: parseDouble(json['hips_initial_dec']),
      defaultFov: parseDouble(json['hips_initial_fov']),
      tMin: parseDouble(json['t_min']),
      tMax: parseDouble(json['t_max']),
    );
  }
}