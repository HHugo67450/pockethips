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
          const Divider(color: Color(0xFF30363D), height: 1),
        itemBuilder: (_, index) {
          final registriesGroup = registriesGroups[index];
          final isSelected =
          selectedProviders.contains(registriesGroup.displayName);

          return CheckboxListTile(
            activeColor: Colors.blue,
            checkColor: Colors.white,
            value: isSelected,
            onChanged: (_) {
              ref.read(filtersProvider.notifier)
                  .toggleProvider(registriesGroup.displayName);
            },

            title: Text(
              registriesGroup.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            subtitle: Text(
              '${registriesGroup.hipsRegistries.length} registries',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          );
        },
      ),
    );
  }


  Widget _buildRegistryDialogContent(
      BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Registries',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: _buildDialogBody(ref),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Confirm Selection',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
    final registriesGroups = ref.watch(hipsRegistryGroupsProvider).maybeWhen(
      data: (groups) => groups,
      orElse: () => null,
    );

    final totalProviders = registriesGroups?.length ?? 0;
    final isAllSelected = selectedProviders.length == totalProviders && totalProviders > 0;

    final buttonText = isAllSelected
        ? 'All Selected'
        : (selectedProviders.isEmpty
            ? 'Filter by provider'
            : '${selectedProviders.length} Selected');

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF21262D),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
          Expanded(
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: Colors.white70,
            size: 20,
          ),
        ],
      ),
    );
  }
}