import 'package:flutter/material.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/build_context.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final bool isLoading;
  final String loadingText;

  const PrimaryButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.isLoading = false,
    this.loadingText = 'Please wait...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? () {} : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(context.mediaQuery.size.height * 0.06),
      ),
      child: isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    backgroundColor: Colors.blue,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(loadingText),
              ],
            )
          : child,
    );
  }
}
