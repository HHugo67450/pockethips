import 'package:pocket_hips/data/hips/hips_registry.dart';

class HipsRegistryGroup {
  final String displayName;
  final List<HipsRegistry> hipsRegistries;

  HipsRegistryGroup({
    required this.displayName,
    required this.hipsRegistries,
  });

  static List<HipsRegistryGroup> fromRegistries(List<HipsRegistry> registries) {
    final Map<String, List<HipsRegistry>> groups = {};

    for (final registry in registries) {
      final provider = registry.provider;
      groups.putIfAbsent(provider, () => []);
      groups[provider]!.add(registry);
    }

    return groups.entries.map((entry) =>
      HipsRegistryGroup(displayName: entry.key, hipsRegistries: entry.value)
    ).toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));
  }
}