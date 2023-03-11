import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeatureOption extends StatelessWidget {
  final IconData icon;
  final String name;
  final String? additionalInfo;

  const FeatureOption({
    super.key,
    required this.icon,
    required this.name,
    this.additionalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        InkWell(
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 1, color: Colors.black)
              // color: optionColor,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(icon),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    if (additionalInfo != null) Text(additionalInfo!)
                  ],
                )),
              ],
            ),
          ),
          onTap: () {},
        ),
        const SizedBox(height: 10,),
      ],
    );
  }
}
