import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/filters/filters_notifier.dart';
import '../../notifiers/hips/hips_registry_notifier.dart';

class FilterRegistries extends ConsumerWidget {
  const FilterRegistries({super.key});

  Widget _buildDialogBody(
      WidgetRef ref) {
    final selectedProviders = ref.watch(filtersProvider).selectedProviders;
    final registriesGroups = ref.watch(hipsRegistryGroupsProvider).maybeWhen(
      data: (groups) => groups,
      orElse: () => null,
    );
    
    if (registriesGroups == null) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (registriesGroups.isEmpty) {
      return const Center(
        child: Text(
          "No providers available",
          style:TextStyle(color: Colors.grey),
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      child: ListView.separated(
        itemCount: registriesGroups.length,
        separatorBuilder: (_, __) =>
          const Divider(color: Colors.grey, height: 1),
        itemBuilder: (_, index) {
          final registriesGroup = registriesGroups[index];
          final isSelected =
          selectedProviders.contains(registriesGroup.displayName);

          return CheckboxListTile(
            activeColor: Colors.amber,
            checkColor: Colors.black,
            value: isSelected,
            onChanged: (_) {
              ref.read(filtersProvider.notifier)
                  .toggleProvider(registriesGroup.displayName);
            },

            title: Text(
              registriesGroup.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            subtitle: Text(
              '${registriesGroup.hipsRegistries.length} registries',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

            controlAffinity: ListTileControlAffinity.trailing,

            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          );
        },
      ),
    );
  }


  Widget _buildRegistryDialogContent(
      BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedProviders = ref.watch(filtersProvider).selectedProviders;

    return Dialog(
      backgroundColor: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select providers (${selectedProviders.length})',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: _buildDialogBody(ref),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProviders = ref.watch(filtersProvider).selectedProviders;
    final isAnySelectedProviders = selectedProviders.isNotEmpty;
    final textColor = isAnySelectedProviders ? Colors.black : Colors.white;
    final buttonBackgroundColor = isAnySelectedProviders
        ? Colors.amber
        : const Color(0xFF1F2228);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBackgroundColor,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          onPressed: () {
            showDialog(
              context: context,
              builder:(dialogContext) {
                return Consumer(
                  builder: (context, ref, _) {
                    return _buildRegistryDialogContent(
                        context, ref
                    );
                  },
                );
              },
            );
          },

          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAnySelectedProviders) ...[
                Text(
                  '${selectedProviders.length}',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                'Filter by provider',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
    );
  }
}