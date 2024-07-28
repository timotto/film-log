import 'package:film_log/model/gear.dart';
import 'package:film_log/pages/gear/widgets/gear_multiselect_page.dart';
import 'package:film_log/service/gear_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultiselectEditTile<T extends Gear> extends StatelessWidget {
  const MultiselectEditTile({
    super.key,
    required this.label,
    required this.values,
    required this.repo,
    required this.edit,
    required this.onUpdate,
    this.filter,
  });

  final String label;
  final List<T> values;
  final GearRepo<T> repo;
  final bool edit;
  final void Function(List<T>) onUpdate;
  final bool Function(T)? filter;

  Future<void> _onTap(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => GearMultiselectPage(
        label: label,
        values: values,
        repo: repo,
        filter: filter,
      ),
    ));

    if (result != null) {
      onUpdate(result);
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: _title(),
        subtitle: _subtitle(),
        trailing: edit ? const Icon(Icons.edit) : null,
        onTap: edit ? () => _onTap(context) : null,
      );

  Widget _title() => values.isNotEmpty
      ? Text(values.map((item) => item.collectionTitle()).join(', '))
      : Text(label);

  Widget? _subtitle() => values.isNotEmpty ? Text(label) : null;
}
