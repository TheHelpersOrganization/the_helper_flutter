import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/admin_home_controller.dart';

class AdminLineChart extends ConsumerWidget {
  const AdminLineChart(
      {super.key,
      required this.lineData,
      required this.chartMaxY,
      this.chartMaxX,
      this.chartMinX,
      required this.filterValue});

  final List<LineChartBarData> lineData;
  final double chartMaxY;
  final double? chartMaxX;
  final double? chartMinX;
  final int filterValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolTipIndex = ref.watch(showToolTip);
    final newLineData = lineData.map(
      (e) {
        return e.copyWith(
            showingIndicators: toolTipIndex != -1 ? [toolTipIndex] : []);
      },
    ).toList();

    return LineChart(
        duration: const Duration(milliseconds: 250),
        LineChartData(
            minX: chartMinX ?? 0,
            maxX: chartMaxX ?? 11,
            minY: 0,
            maxY: chartMaxY,
            titlesData: LineTitles.getTitleData(chartMaxY, filterValue),
            showingTooltipIndicators: [
              if (toolTipIndex != -1)
                ShowingTooltipIndicators([
                  LineBarSpot(lineData[0], 0, lineData[0].spots[toolTipIndex]),
                  LineBarSpot(lineData[1], 0, lineData[1].spots[toolTipIndex]),
                  LineBarSpot(lineData[2], 0, lineData[2].spots[toolTipIndex])
                ])
            ],
            borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                )),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.black.withOpacity(0.6),
              ),
              handleBuiltInTouches: false,
              touchCallback: (event, response) {
                if (response != null &&
                    response.lineBarSpots != null &&
                    event is FlTapUpEvent) {
                  final x = response.lineBarSpots!.first.spotIndex;
                  final isShowing = toolTipIndex == x;
                  if (isShowing) {
                    ref.read(showToolTip.notifier).state = -1;
                  } else {
                    ref.read(showToolTip.notifier).state = x;
                  }
                }
              },
            ),
            clipData: chartMinX != null
                ? const FlClipData.horizontal()
                : const FlClipData.none(),
            lineBarsData: newLineData));
  }
}

class LineTitles {
  static getTitleData(double maxValue, int filterValue) => FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true, getTitlesWidget: (_, __) => const Text('')),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: filterValue == 2
                ? bottomTitleYearWidgets
                : bottomTitleMonthWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxValue / 5,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      );

  static Widget bottomTitleMonthWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('JAN', style: style);
        break;
      case 1:
        text = const Text('FEB', style: style);
        break;
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 3:
        text = const Text('APR', style: style);
        break;
      case 4:
        text = const Text('MAY', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 6:
        text = const Text('JUL', style: style);
        break;
      case 7:
        text = const Text('AUG', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      case 9:
        text = const Text('OCT', style: style);
        break;
      case 10:
        text = const Text('NOV', style: style);
        break;
      case 11:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  static Widget bottomTitleYearWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          )),
    );
  }

  static Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 9,
    );
    return Text(value.toInt().toString(),
        style: style, textAlign: TextAlign.left);
  }
}
