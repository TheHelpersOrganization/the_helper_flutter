import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/domain/data_log.dart';
import 'package:the_helper/src/common/domain/data_yearly_log.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/admin_home/swipeable_chart.dart';

import '../../controllers/admin_home_controller.dart';
import 'admin_data_holder.dart';
import 'admin_linechart.dart';
// import 'package:fpdart/fpdart.dart';

class AdminLineChartView extends ConsumerStatefulWidget {
  const AdminLineChartView({
    super.key,
  });

  @override
  ConsumerState<AdminLineChartView> createState() => _AdminLineChartViewState();
}

class _AdminLineChartViewState extends ConsumerState<AdminLineChartView> {
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

  double _getMinYear(List<DataYearlyLog> data) {
    int min = DateTime.now().year;
    for (var i in data) {
      if (i.year < min) {
        min = i.year;
      }
    }
    return min.toDouble();
  }

  List<LineChartBarData> _getMonthLineData({
    required DataLog activityCount,
    required DataLog accountCount,
    required DataLog orgCount,
    required bool showActivity,
    required bool showAccount,
    required bool showOrganization,
  }) {
    List<LineChartBarData> lineData = [
      // Activity
      LineChartBarData(
        show: showActivity,
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
        show: showAccount,
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
        show: showOrganization,
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
    required bool showActivity,
    required bool showAccount,
    required bool showOrganization,
  }) {
    List<LineChartBarData> lineData = [
      // Activity
      LineChartBarData(
        show: showActivity,
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
        show: showAccount,
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
        show: showOrganization,
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
    final showAccount = ref.watch(isAccountLineSeenProvider);
    final showOrganization = ref.watch(isOrganizationLineSeenProvider);
    final showActivity = ref.watch(isActivityLineSeenProvider);

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
            InkWell(
              onTap: () {
                ref.read(isActivityLineSeenProvider.notifier).state =
                    !showActivity;
              },
              child: Row(
                children: [
                  Container(
                    height: 5,
                    width: 20,
                    color: showActivity ? Colors.blue : Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text('Activity'),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () {
                ref.read(isAccountLineSeenProvider.notifier).state =
                    !showAccount;
              },
              child: Row(
                children: [
                  Container(
                    height: 5,
                    width: 20,
                    color: showAccount ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text('Account'),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () {
                ref.read(isOrganizationLineSeenProvider.notifier).state =
                    !showOrganization;
              },
              child: Row(
                children: [
                  Container(
                    height: 5,
                    width: 20,
                    color: showOrganization ? Colors.redAccent : Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text('Organization'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        chartData.when(
            error: (_, __) => const CustomErrorWidget(),
            loading: () => Expanded(
                  child: Center(
                    child: AdminDataHolder(
                      itemCount: 1,
                      itemWidth: context.mediaQuery.size.width * 0.9,
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
              final chartMinX = _getMinYear(data.account.yearly +
                  data.activity.yearly +
                  data.organization.yearly);
              final chartMaxX = DateTime.now().year.toDouble();
              return Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: filterValue == 2
                        ? SwipeableChart(
                            minX: chartMinX,
                            maxX: chartMaxX,
                            yearNumShow: 4,
                            builder: (minX, maxX) {
                              return AdminLineChart(
                                chartMinX: minX,
                                chartMaxX: maxX,
                                chartMaxY: chartMaxY,
                                filterValue: filterValue,
                                lineData: _getYearLineData(
                                    activityCount: data.activity,
                                    showActivity: showActivity,
                                    accountCount: data.account,
                                    showAccount: showAccount,
                                    orgCount: data.organization,
                                    showOrganization: showOrganization),
                              );
                            })
                        : AdminLineChart(
                            chartMaxY: chartMaxY,
                            filterValue: filterValue,
                            lineData: _getMonthLineData(
                                activityCount: data.activity,
                                showActivity: showActivity,
                                accountCount: data.account,
                                showAccount: showAccount,
                                orgCount: data.organization,
                                showOrganization: showOrganization),
                          )),
              );
            }),
      ],
    );
  }
}
