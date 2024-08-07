import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class WearListView extends StatefulWidget {
  const WearListView({
    super.key,
    required this.children,
    this.itemExtend = 48,
    this.selectedIndex,
    this.controller,
  });

  final List<Widget> children;
  final double itemExtend;
  final int? selectedIndex;
  final ScrollController? controller;

  @override
  State<WearListView> createState() => _WearListViewState();

  static Widget useDelegate({
    ScrollController? controller,
    double itemExtent = 48,
    required ListWheelChildDelegate childDelegate,
  }) =>
      ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: itemExtent,
        childDelegate: childDelegate,
        diameterRatio: RenderListWheelViewport.defaultDiameterRatio,
        perspective: RenderListWheelViewport.defaultPerspective * 2,
      );
}

class _WearListViewState extends State<WearListView> {
  late final ScrollController _controller;

  @override
  void initState() {
    final double initialScrollOffset =
        widget.itemExtend * (widget.selectedIndex ?? 0);

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
        controller: widget.controller ?? _controller,
        itemExtent: widget.itemExtend,
        diameterRatio: RenderListWheelViewport.defaultDiameterRatio,
        perspective: RenderListWheelViewport.defaultPerspective * 2,
        children: widget.children,
      );
}
