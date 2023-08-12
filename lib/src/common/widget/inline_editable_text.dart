import 'package:flutter/material.dart';

class InlineEditableText extends StatefulWidget {
  const InlineEditableText({
    Key? key,
    required this.text,
    required this.style,
  }) : super(key: key);

  final String text;
  final TextStyle? style;

  @override
  State<InlineEditableText> createState() => _InlineEditableTextState();
}

class _InlineEditableTextState extends State<InlineEditableText> {
  var _isEditing = false;
  final _focusNode = FocusNode();
  late String _text = widget.text;
  late final TextStyle? _style = widget.style;
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: _text);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _isEditing = false);
      } else {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.value.text.runes.length,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => setState(() {
        _isEditing = !_isEditing;
        _focusNode.requestFocus();
      }),
      child: TextField(
        maxLines: 1,
        style: _style,
        focusNode: _focusNode,
        controller: _controller,
        onSubmitted: (changed) {
          setState(() {
            _text = changed;
            _isEditing = false;
          });
        },
        showCursor: _isEditing,
        cursorColor: Colors.black,
        enableInteractiveSelection: _isEditing,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 4.4,
          ),
          border: _isEditing
              ? const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                )
              : InputBorder.none,
        ),
      ),
    );
  }
}
