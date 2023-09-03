import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/domain/data_log.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';

import '../../controllers/admin_home_controller.dart';
import 'admin_data_holder.dart';
// import 'package:fpdart/fpdart.dart';

class AdminLineChart extends ConsumerStatefulWidget {
  const AdminLineChart({
    super.key,
  });

  @override
  ConsumerState<AdminLineChart> createState() => _AdminLineChartState();
}

class _AdminLineChartState extends ConsumerState<AdminLineChart> {
  int filterValue = 0;

  double _getMaxValue(List<int> totalData) {
    var maxValue = 50;

    if (totalData.isNotEmpty) {
      maxValue = totalData.max;
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
    return chartMaxY;
  }

  List<LineChartBarData> _getMonthLineData({
    required DataLog activityCount,
    required DataLog accountCount,
    required DataLog orgCount,
  }) {
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
        spots: activityCount.monthly
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
        spots: accountCount.monthly
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
        spots: orgCount.monthly
            .map((e) => FlSpot(e.month.toDouble() - 1, e.count.toDouble()))
            .toList(),
      ),
    ];

    return lineData;
  }

  List<LineChartBarData> _getYearLineData({
    required DataLog activityCount,
    required DataLog accountCount,
    required DataLog orgCount,
  }) {
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
        spots: activityCount.yearly
            .map((e) => FlSpot(e.year.toDouble() - 1, e.count.toDouble()))
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
        spots: accountCount.yearly
            .map((e) => FlSpot(e.year.toDouble() - 1, e.count.toDouble()))
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
        spots: orgCount.yearly
            .map((e) => FlSpot(e.year.toDouble() - 1, e.count.toDouble()))
            .toList(),
      ),
    ];

    return lineData;
  }

  @override
  void initState() {
    super.initState();
    filterValue = 0;
  }

  @override
  Widget build(BuildContext context) {
    final chartData = ref.watch(adminChartDataProvider(filterValue));

    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ChoiceChip(
              label: const Text('This year'),
              selected: filterValue == 0,
              onSelected: (value) {
                setState(() {
                  filterValue = 0;
                });
              },
            ),
            ChoiceChip(
              label: const Text('Last year'),
              selected: filterValue == 1,
              onSelected: (value) {
                setState(() {
                  filterValue = 1;
                });
              },
            ),
            ChoiceChip(
              label: const Text('All time'),
              selected: filterValue == 2,
              onSelected: (value) {
                setState(() {
                  filterValue = 2;
                });
              },
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 5,
              width: 20,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text('Activity'),
            const SizedBox(
              width: 15,
            ),
            Container(
              height: 5,
              width: 20,
              color: Colors.orange,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text('Account'),
            const SizedBox(
              width: 15,
            ),
            Container(
              height: 5,
              width: 20,
              color: Colors.redAccent,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text('Organization'),
          ],
        ),
        const SizedBox(height: 15),
        chartData.when(
            error: (_, __) => const ErrorScreen(),
            loading: () => Expanded(
                  child: Center(
                    child: AdminDataHolder(
                      itemCount: 1,
                      itemWidth: context.mediaQuery.size.width * 0.8,
                      itemHeight: 350,
                    ),
                  ),
                ),
            data: (data) {
              List<int> valueHolder;
              if (filterValue == 2) {
                var dataList = data.account.yearly +
                    data.activity.yearly +
                    data.organization.yearly;
                valueHolder = dataList.map((e) => e.count).toList();
              } else {
                var dataList = data.account.monthly +
                    data.activity.monthly +
                    data.organization.monthly;
                valueHolder = dataList.map((e) => e.count).toList();
              }

              final chartMaxY = _getMaxValue(valueHolder);
              return Expanded(
                child: Container(
                  // height: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LineChart(
                      duration: const Duration(milliseconds: 250),
                      LineChartData(
                          minX: 0,
                          maxX: 11,
                          minY: 0,
                          maxY: chartMaxY,
                          titlesData:
                              LineTitles.getTitleData(chartMaxY, filterValue),
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
                          lineBarsData: filterValue == 2
                              ? _getYearLineData(
                                  activityCount: data.activity,
                                  accountCount: data.account,
                                  orgCount: data.organization)
                              : _getMonthLineData(
                                  activityCount: data.activity,
                                  accountCount: data.account,
                                  orgCount: data.organization))),
                ),
              );
            }),
      ],
    );
  }
}

class LineTitles {
  static getTitleData(double maxValue, int filterValue) => FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
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
