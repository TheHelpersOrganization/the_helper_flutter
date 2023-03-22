import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DebounceSearchBar extends StatefulWidget {
  final Duration _debounceDuration;
  final void Function(String value)? _onChanged;
  final void Function()? _onClear;
  final void Function(String value)? _onDebounce;

  const DebounceSearchBar({
    super.key,
    required Duration debounceDuration,
    void Function(String value)? onChanged,
    void Function()? onClear,
    void Function(String value)? onDebounce,
  })  : _debounceDuration = debounceDuration,
        _onChanged = onChanged,
        _onClear = onClear,
        _onDebounce = onDebounce;

  @override
  State<DebounceSearchBar> createState() {
    return _DebounceSearchBarState();
  }
}

class _DebounceSearchBarState extends State<DebounceSearchBar> {
  final TextEditingController _inputController = TextEditingController();
  final BehaviorSubject<String> _searchAfterDuration =
      BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    final onDebounce = widget._onDebounce;
    if (onDebounce != null) {
      _searchAfterDuration
          .debounceTime(widget._debounceDuration)
          .listen((event) => onDebounce(event));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _inputController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _inputController.clear();
            widget._onClear?.call();
          },
        ),
      ),
      onChanged: (value) => _internalOnChange(value),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
    _searchAfterDuration.close();
  }

  void _internalOnChange(String value) {
    final onChange = widget._onChanged;
    if (onChange != null) {
      onChange(value);
    }
    _searchAfterDuration.add(value);
  }
}
