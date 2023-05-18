import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int total;
  final String info;

  const SummaryCard({
    super.key,
    required this.title,
    required this.total,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
      height: 90,
      width: 150,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              total.toString(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              info,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.green),
            ),
          ]),
    ));
  }
}
