import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SkillListItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final double hour;
  final Color color;

  const SkillListItem({
    super.key,
    required this.name,
    required this.icon,
    required this.hour,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat.compact(locale: "en_US");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Chip(
              avatar: Icon(icon),
              label: Text(name),
              elevation: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              '${f.format(hour)} h',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
