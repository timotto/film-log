import 'package:film_log_wear/widgets/wear_multiselect_list_view.dart';
import 'package:flutter/material.dart';

import '../model/filter.dart';

class EditFiltersPage extends StatelessWidget {
  const EditFiltersPage({
    super.key,
    required this.selected,
    required this.values,
  });

  final List<Filter> selected;
  final List<Filter> values;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: WearMultiSelectListView(
          selected: selected,
          values: values,
          titleBuilder: (filter) => filter.label,
        ),
      );
}
