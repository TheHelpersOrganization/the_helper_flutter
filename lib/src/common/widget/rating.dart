import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final int rating;
  final int maxRating;
  final Widget icon;
  final Widget? trailingIcon;

  const Rating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.icon = const Icon(Icons.star, color: Colors.amber),
    this.trailingIcon = const Icon(Icons.star, color: Colors.grey),
  }) : assert(rating <= maxRating);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        trailingIcon != null ? maxRating : rating,
        (index) {
          final rate = index + 1;
          return rate <= rating
              ? icon
              : (trailingIcon ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
