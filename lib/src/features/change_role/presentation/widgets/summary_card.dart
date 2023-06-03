import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String data;
  final String info;
  final String path;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.data,
    required this.info,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.goNamed(path),
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Icon(icon),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(info),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(data),
                ),
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
