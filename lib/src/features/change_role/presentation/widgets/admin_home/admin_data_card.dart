import 'package:flutter/material.dart';

class AdminDataCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int? data;
  final Function()? onTap;
  final double? height;

  const AdminDataCard({
    super.key,
    required this.title,
    required this.icon,
    this.data,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).primaryColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    data.toString(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Text(title,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary))
          ],
        ),
      ),
      ),
    );
  }
}