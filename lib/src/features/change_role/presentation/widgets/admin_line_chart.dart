import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_helper/src/features/activity/domain/activity_count.dart';
import 'package:the_helper/src/features/activity/domain/activity_log.dart';

class AdminLineChart extends StatelessWidget {
  final ActivityLog data;
  const AdminLineChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    var dateNow = DateTime.now();
    List<ActivityCount> activityCount =
        data.monthly.filter((e) => e.year == dateNow.year).toList();

    List<LineChartBarData> lineData = [
      // Activity
      LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.blue,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: activityCount
            .map((e) => FlSpot((e.month-1) as double, e.count as double))
            .toList(),
      ),
    ];

    return LineChart(LineChartData(
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 500,
        titlesData: LineTitles.getTitleData(),
        borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(
                color: Colors.black,
                width: 1,
              ),
              bottom: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            )),
        gridData: const FlGridData(
          show: false,
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white10.withOpacity(0.8),
          )
        ),
        lineBarsData: lineData));
  }
}

class LineTitles {
  static getTitleData() => const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      );

  static Widget bottomTitleWidgets(double value, TitleMeta meta) {
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

  static Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 9,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '100';
        break;
      case 2:
        text = '200';
        break;
      case 3:
        text = '300';
        break;
      case 4:
        text = '400';
        break;
      case 5:
        text = '500';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
