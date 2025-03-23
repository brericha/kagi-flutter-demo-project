import 'package:flutter/material.dart';
import 'package:kite/app/cubit/app_cubit.dart';
import 'package:kite/l10n/l10n.dart';
import 'package:kite/settings/cubit/settings_cubit.dart';

class CategorySettings extends StatefulWidget {
  const CategorySettings({super.key});

  @override
  State<CategorySettings> createState() => _CategorySettingsState();
}

class _CategorySettingsState extends State<CategorySettings> {
  late final List<String> _allCategories;
  late final List<String> _enabledCategories;

  @override
  void initState() {
    super.initState();

    _allCategories =
        context.appState.data!.categories.map((e) => e.name).toList()
          ..add('Today in History');
    // Manually add Today in History because it's excluded from the categories
    // list since it's a "special" category
    _enabledCategories = List<String>.from(context.settingsState.categories);
  }

  void _save() {
    context.settingsCubit.setCategories(_enabledCategories);
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_enabledCategories.length > 1 &&
          _enabledCategories.contains(category)) {
        _enabledCategories.remove(category);
      } else {
        _enabledCategories.add(category);
      }

      _save();
    });
  }

  @override
  Widget build(BuildContext context) {
    final combinedList = <String>[..._enabledCategories];
    for (final category in _allCategories) {
      if (!_enabledCategories.contains(category)) {
        combinedList.add(category);
      }
    }

    return ReorderableListView.builder(
      padding: EdgeInsets.only(
        // Bottom padding to avoid system home pill
        bottom: MediaQuery.of(context).viewPadding.bottom,
      ),
      header: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(context.l10n.settingsCategoriesLabel),
      ),
      itemCount: combinedList.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          final item = combinedList[oldIndex];

          // Only allow reordering of enabled categories
          if (!_enabledCategories.contains(item)) {
            return;
          }

          // Convert indices from the combined list to the enabled list
          final enabledIndex = _enabledCategories.indexOf(item);

          // Calculate where to insert in the enabled list
          var targetIndex = newIndex;

          // Adjust for the fact that we're moving within the combined
          // list
          if (oldIndex < newIndex) {
            targetIndex -= 1;
          }

          // Ensure we don't place an enabled item in the disabled section
          if (targetIndex >= _enabledCategories.length) {
            targetIndex = _enabledCategories.length - 1;
          }

          if (targetIndex >= 0) {
            _enabledCategories
              ..removeAt(enabledIndex)
              ..insert(targetIndex, item);
            _save();
          }
        });
      },
      itemBuilder: (context, index) {
        final category = combinedList[index];
        final isEnabled = _enabledCategories.contains(category);

        return ListTile(
          key: ValueKey(category),
          title: Text(category),
          leading: Icon(
            isEnabled ? Icons.check_circle : Icons.circle_outlined,
            color: isEnabled ? Colors.blue : Colors.grey,
          ),
          trailing: isEnabled ? const Icon(Icons.drag_handle) : null,
          onTap: () {
            _toggleCategory(category);
          },
        );
      },
    );
  }
}
