import 'package:film_log/model/gear.dart';
import 'package:film_log/service/gear_repo.dart';
import 'package:flutter/material.dart';

typedef OnUpdateFn<T extends Gear> = void Function(dynamic) Function(
    T Function(dynamic));

class GearViewPage<T extends Gear> extends StatefulWidget {
  const GearViewPage({
    super.key,
    required this.item,
    required this.repo,
    required this.tilesBuilder,
    this.create,
  });

  final T item;
  final bool? create;
  final GearRepo<T> repo;
  final List<Widget> Function(
    BuildContext context,
    T item,
    bool edit,
    OnUpdateFn<T> onUpdate,
  ) tilesBuilder;

  @override
  State<StatefulWidget> createState() => _GearViewPageState<T>();
}

class _GearViewPageState<T extends Gear> extends State<GearViewPage<T>> {
  late T item;
  bool edit = false;

  @override
  void initState() {
    item = widget.item;
    if (widget.create ?? false) {
      edit = true;
    }
    super.initState();
  }

  void _toggleEdit() {
    setState(() {
      edit = !edit;
    });
  }

  Future<void> _save() async {
    final create = widget.create ?? false;
    if (create) {
      await widget.repo.add(item);
    } else {
      await widget.repo.update(item);
    }
    setState(() {
      edit = !edit;
    });
    if (create) {
      if (!mounted || !context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future<void> _delete(BuildContext context) async {
    await widget.repo.delete(item);
    if (!mounted || !context.mounted) return;
    Navigator.of(context).pop();
  }

  void Function(V? value) _onUpdate<V>(T Function(V) fn) => (value) {
        if (value == null) return;
        setState(() {
          item = fn(value);
        });
      };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(item.listItemTitle()),
          actions: [
            if (!(edit || (widget.create ?? false)))
              IconButton(
                onPressed: () => _delete(context),
                icon: const Icon(Icons.delete),
              ),
            if (!edit)
              IconButton(
                onPressed: _toggleEdit,
                icon: const Icon(Icons.edit),
              ),
            if (edit)
              IconButton(
                onPressed: item.validate() ? _save : null,
                icon: const Icon(Icons.check),
              ),
          ],
        ),
        body: ListView(
          children: widget.tilesBuilder(context, item, edit, _onUpdate),
        ),
      );
}
