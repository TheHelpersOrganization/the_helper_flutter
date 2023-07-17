import 'package:flutter/material.dart';

class PenddingRequestData extends StatelessWidget {
  final String name;
  final IconData icon;
  final int count;
  final double? height;
  final double? width;
  final Function()? onTap;

  const PenddingRequestData({
    super.key,
    required this.name,
    required this.icon,
    required this.count,
    this.height,
    this.width,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: height,
        // width: width,
        child: Badge.count(
          offset: const Offset(-4, 0),
          count: count,
          child: Card(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Icon(icon)),
                    Center(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ))),
                  ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
