import 'package:flutter/material.dart';

class InlineEditableText extends StatefulWidget {
  const InlineEditableText({
    Key? key,
    required this.initialValue,
    required this.style,
    this.showEditButton = true,
    this.onSubmitted,
  }) : super(key: key);

  final String initialValue;
  final TextStyle? style;
  final bool showEditButton;
  final ValueChanged<String>? onSubmitted;

  @override
  State<InlineEditableText> createState() => _InlineEditableTextState();
}

class _InlineEditableTextState extends State<InlineEditableText> {
  final _focusNode = FocusNode();
  bool _isEditing = false;
  late String _text = widget.initialValue;
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

  void _setEditing(bool isEditing) {
    setState(() => _isEditing = isEditing);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => _setEditing(!_isEditing),
      child: TextField(
        minLines: 1,
        maxLines: 10,
        style: _style,
        textAlignVertical: TextAlignVertical.center,
        focusNode: _focusNode,
        controller: _controller,
        onSubmitted: (changed) {
          setState(() {
            _text = changed;
            _isEditing = false;
          });
          widget.onSubmitted?.call(changed);
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
          suffixIcon: widget.showEditButton
              ? IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _setEditing(!_isEditing);
                  },
                  icon: const Icon(Icons.edit_outlined),
                )
              : null,
        ),
      ),
    );
  }
}
