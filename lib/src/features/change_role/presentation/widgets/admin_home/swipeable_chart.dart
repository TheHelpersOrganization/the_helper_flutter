import 'dart:math';

import 'package:flutter/material.dart';

class SwipeableChart extends StatefulWidget {
  const SwipeableChart({
    super.key,
    required this.maxX,
    required this.minX,
    required this.builder,
    required this.yearNumShow,
  });

  final double maxX;
  final double minX;
  final int yearNumShow;
  final Widget Function(double, double) builder;

  @override
  State<SwipeableChart> createState() => _SwipeableChartState();
}

class _SwipeableChartState extends State<SwipeableChart> {
  late double minX;
  late double maxX;

  late double lastMaxXValue;
  late double lastMinXValue;

  @override
  void initState() {
    super.initState();
    minX = widget.maxX - widget.yearNumShow;
    maxX = widget.maxX;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          minX = widget.maxX - widget.yearNumShow;
          maxX = widget.maxX;
        });
      },
      onHorizontalDragStart: (details) {
        lastMinXValue = minX;
        lastMaxXValue = maxX;
      },
      onHorizontalDragUpdate: (details) {
        var horizontalDistance = details.primaryDelta ?? 0;
        if (horizontalDistance == 0) return;
        var lastMinMaxDistance = max(lastMaxXValue - lastMinXValue, 0.0);

        setState(() {
          minX -= lastMinMaxDistance * 0.005 * horizontalDistance;
          maxX -= lastMinMaxDistance * 0.005 * horizontalDistance;

          if (minX < widget.minX) {
            minX = widget.minX;
            maxX = widget.minX + lastMinMaxDistance;
          }
          if (maxX > widget.maxX) {
            maxX = widget.maxX;
            minX = maxX - lastMinMaxDistance;
          }
        });
      },
      child: widget.builder(minX, maxX),
    );
  }
}
