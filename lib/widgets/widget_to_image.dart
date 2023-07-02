import 'package:flutter/material.dart';

class WidgetToImage extends StatefulWidget {
  const WidgetToImage({super.key, required this.targetWidget});
  final Widget targetWidget;

  @override
  State<WidgetToImage> createState() => _WidgetToImageState();
}

class _WidgetToImageState extends State<WidgetToImage> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: widget.targetWidget,
    );
  }
}
