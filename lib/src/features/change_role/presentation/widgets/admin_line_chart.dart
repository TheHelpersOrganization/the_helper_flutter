import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_helper/src/features/activity/domain/activity_count.dart';
import 'package:the_helper/src/features/activity/domain/activity_log.dart';

import '../controllers/admin_home_controller.dart';

class AdminLineChart extends ConsumerWidget {
  const AdminLineChart({
    super.key,
    required this.accountData,
    required this.activityData,
    required this.organizationData,
  });

  final ActivityLog accountData;
  final ActivityLog activityData;
  final ActivityLog organizationData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dateNow = DateTime.now();
    final filterValue = ref.watch(chartFilterProvider);
    List<ActivityCount> activityCount = activityData.monthly
        .filter((e) => e.year == (dateNow.year - filterValue))
        .toList();
    List<ActivityCount> accountCount = accountData.monthly
        .filter((e) => e.year == (dateNow.year - filterValue))
        .toList();
    List<ActivityCount> orgCount = organizationData.monthly
        .filter((e) => e.year == (dateNow.year - filterValue))
        .toList();
    // final activityCount = activityData.monthly;

    var maxValue = 50;

    final totalData = activityCount + accountCount + orgCount;
    if (totalData.isNotEmpty) {
      for (var i in totalData) {
        if (i.count > maxValue) {
          maxValue = i.count;
        }
      }
    }

    var firstDigit = (maxValue / 10).floor();
    var k = 1;
    var ceilValue = 10;
    while (firstDigit > 10) {
      k += 1;
      firstDigit = (firstDigit / 10).floor();
    }

    if (firstDigit < 5) {
      ceilValue = 5;
    }

    final chartMaxY = (ceilValue * pow(10, k)).toDouble();

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
            .map((e) => FlSpot(e.month.toDouble() - 1, e.count.toDouble()))
            .toList(),
      ),

      // account
      LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.orange,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: accountCount
            .map((e) => FlSpot(e.month.toDouble() - 1, e.count.toDouble()))
            .toList(),
      ),

      // org
      LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.redAccent,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: orgCount
            .map((e) => FlSpot(e.month.toDouble() - 1, e.count.toDouble()))
            .toList(),
      ),
    ];

    return LineChart(LineChartData(
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: chartMaxY,
        titlesData: LineTitles.getTitleData(chartMaxY),
        gridData: FlGridData(
          show: false,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: maxValue * 0.1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              // color: Colors.white10,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(
              // color: Colors.white10,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
            show: true,
            border: const Border(
              // left: BorderSide(
              //   color: Colors.black,
              //   width: 1,
              // ),
              bottom: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            )),
        lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black.withOpacity(0.6),
        )),
        lineBarsData: lineData));
  }
}

class LineTitles {
  static getTitleData(double maxValue) => FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
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
    // String text;
    // switch (value.toInt()) {
    //   case 1:
    //     text = '100';
    //     break;
    //   case 2:
    //     text = '200';
    //     break;
    //   case 3:
    //     text = '300';
    //     break;
    //   case 4:
    //     text = '400';
    //     break;
    //   case 5:
    //     text = '500';
    //     break;
    //   default:
    //     return Container();
    // }

    return Text(value.toInt().toString(),
        style: style, textAlign: TextAlign.left);
  }
}
