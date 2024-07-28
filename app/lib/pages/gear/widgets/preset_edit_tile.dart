import 'package:film_log/widgets/select_list_widget.dart';
import 'package:flutter/material.dart';

class PresetEditTile<T> extends StatelessWidget {
  const PresetEditTile({
    super.key,
    required this.label,
    required this.values,
    required this.value,
    required this.edit,
    required this.onUpdate,
  });

  final String label;
  final Map<T, String> values;
  final T value;
  final bool edit;
  final void Function(T) onUpdate;

  Future<void> _onTap(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _PresetListWidget(
            label: label,
            items: values.entries.toList(growable: false),
            value: value,
          ),
        ));
    if (result != null) {
      onUpdate(result);
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(values[value] ?? ''),
        subtitle: Text(label),
        trailing: edit ? const Icon(Icons.edit) : null,
        onTap: edit ? () => _onTap(context) : null,
      );
}

class _PresetListWidget<T> extends StatelessWidget {
  const _PresetListWidget({
    required this.label,
    required this.items,
    this.value,
  });

  final String label;
  final List<MapEntry<T, String>> items;
  final T? value;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(label)),
        body: SelectListWidget(
          items: items,
          value: value,
          onTap: (value) => Navigator.of(context).pop(value),
        ),
      );
}
