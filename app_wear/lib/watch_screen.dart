import 'package:flutter/material.dart';
import 'package:wear_plus/wear_plus.dart';

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => WatchShape(builder: (context, shape, what) {
    return child;
  } );
}