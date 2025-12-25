class HipsRegistry {
  final String id;
  final String url;

  HipsRegistry({
    required this.id,
    required this.url,
  });

  String get provider {
    const prefix = 'ivo://';
    if (!id.startsWith(prefix)) {
      return 'UNKNOWN';
    }

    final rest = id.substring(prefix.length);
    final slashIndex = rest.indexOf('/');

    return slashIndex == -1
        ? rest
        : rest.substring(0, slashIndex);
  }

  static List<HipsRegistry> fromText(String rawText) {
    final lines = rawText.split('\n');
    final registries = <HipsRegistry>[];

    String? currentId;
    String? currentUrl;

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) {
        continue;
      }

      if (line.startsWith('hips_node_id')) {
        currentId = line.split('=').last.trim();
      } else if (line.startsWith('hips_node_url')) {
        currentUrl = line.split('=').last.trim();
      }

      if (currentId != null && currentUrl != null) {
        registries.add(HipsRegistry(id: currentId, url: currentUrl));
        currentId = null;
        currentUrl = null;
      }
    }

    return registries;
  }
}