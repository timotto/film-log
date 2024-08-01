import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WearListView extends StatefulWidget {
  const WearListView({
    super.key,
    required this.children,
    this.itemExtend = 48,
    this.selectedIndex,
  });

  final List<Widget> children;
  final double itemExtend;
  final int? selectedIndex;

  @override
  State<WearListView> createState() => _WearListViewState();
}

class _WearListViewState extends State<WearListView> {
  late final ScrollController _controller;

  @override
  void initState() {
    final double initialScrollOffset = widget.selectedIndex == null
        ? 0
        : widget.itemExtend * widget.selectedIndex!;

    _controller = ScrollController(
      initialScrollOffset: initialScrollOffset,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListWheelScrollView(
        controller: _controller,
        itemExtent: widget.itemExtend,
        diameterRatio: RenderListWheelViewport.defaultDiameterRatio,
        perspective: RenderListWheelViewport.defaultPerspective * 2,
        children: widget.children,
      );
}
