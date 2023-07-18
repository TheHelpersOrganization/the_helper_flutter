import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/side_sheet.dart';

class DebounceSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final Duration? _debounceDuration;
  final void Function(String value)? _onChanged;
  final void Function()? _onClear;
  final void Function(String value)? _onDebounce;
  final Widget? filter;
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
    this.filter,
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
          .debounceTime(widget._debounceDuration ?? const Duration(seconds: 3))
          .listen((event) => onDebounce(event));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(),
        ),
        if (widget.filter != null) _buildFilter(widget.filter!),
      ],
    );
  }

  Row _buildFilter(Widget body) {
    return Row(
      children: [
        const SizedBox(
          width: 8,
        ),
        IconButton(
            onPressed: () {
              _openSideSheet(body);
            },
            icon: const Icon(Icons.filter_list_rounded)),
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

  void _openSideSheet(Widget body) {
    SideSheet.right(
      context: context,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter',
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close_rounded),
                )
              ],
            ),
            body,
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.clear_outlined,
                      size: 18,
                    ),
                    label: const Text('Clear'),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 3,
                  child: FilledButton(
                    child: const Text('Apply'),
                    onPressed: () {},
                  ),
                )
              ],
            )
          ],
        ),
      ),
      width: context.mediaQuery.size.width * 0.8,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (!widget._isUsingCustomController) _inputController.dispose();
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
