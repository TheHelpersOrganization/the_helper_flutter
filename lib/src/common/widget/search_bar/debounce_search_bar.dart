import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DebounceSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final Duration? _debounceDuration;
  final void Function(String value)? _onChanged;
  final void Function()? _onClear;
  final void Function(String value)? _onDebounce;
  final bool small;
  final String? hintText;
  final String? initialValue;
  final bool _isUsingCustomController;

  const DebounceSearchBar({
    super.key,
    Duration? debounceDuration,
    this.controller,
    void Function(String value)? onChanged,
    void Function()? onClear,
    void Function(String value)? onDebounce,
    this.small = false,
    this.hintText,
    this.initialValue,
  })  : _debounceDuration = debounceDuration,
        _onChanged = onChanged,
        _onClear = onClear,
        _onDebounce = onDebounce,
        _isUsingCustomController = controller != null;

  @override
  State<DebounceSearchBar> createState() {
    return _DebounceSearchBarState();
  }
}

class _DebounceSearchBarState extends State<DebounceSearchBar> {
  late final TextEditingController _inputController;
  final BehaviorSubject<String> _searchAfterDuration =
      BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();

    final onDebounce = widget._onDebounce;
    _inputController =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    if (onDebounce != null) {
      _searchAfterDuration
          .debounceTime(widget._debounceDuration ?? const Duration(seconds: 1))
          .listen((event) {
        if (mounted) {
          onDebounce(event);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(),
        ),
      ],
    );
  }

  TextField _buildTextField() {
    return TextField(
      controller: _inputController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: widget.small ? EdgeInsets.zero : null,
        isDense: widget.small,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _inputController.clear();
            widget._onClear?.call();
          },
        ),
        hintText: widget.hintText,
      ),
      onChanged: (value) => _internalOnChange(value),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchAfterDuration.close();
    if (!widget._isUsingCustomController) _inputController.dispose();
  }

  void _internalOnChange(String value) {
    final onChange = widget._onChanged;
    if (onChange != null) {
      onChange(value);
    }
    _searchAfterDuration.add(value);
  }
}
