import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyListWidget extends StatelessWidget {
  final List<String> description;
  final String buttonTxt;
  final Function()? onPress;

  const EmptyListWidget({
    super.key,
    required this.description,
    required this.buttonTxt,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/empty-folder-optimized.svg',
          height: 100,
          width: 100,
          allowDrawingOutsideViewBox: true,
        ),
        const SizedBox(width: 8,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            for(var i in description)
            Text(
              i,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 13,),
            FilledButton(
              onPressed: onPress,
              child: Text(buttonTxt),
            ),
          ],
        )
      ],
    ),);
  }
}