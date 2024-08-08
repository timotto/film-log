import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:flutter/material.dart';

class WearTextEdit extends StatefulWidget {
  const WearTextEdit({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  State<WearTextEdit> createState() => _WearTextEditState();
}

class _WearTextEditState extends State<WearTextEdit> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(
      text: widget.value,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context) async {
    Navigator.of(context).pop(controller.value.text);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    label: Text(widget.label),
                  ),
                  onSubmitted: (_) => _save(context),
                ),
                IconButton(
                  onPressed: () => _save(context),
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          ),
        ),
      );
}
