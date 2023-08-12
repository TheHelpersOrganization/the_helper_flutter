import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';

class RiverDebounceSearchBar extends ConsumerWidget {
  final StateProvider<String>? provider;
  final AutoDisposeStateProvider<String>? autoDisposeProvider;
  final TextEditingController? controller;
  final Duration? debounceDuration;
  final void Function(String value)? onChanged;
  final void Function()? onClear;
  final void Function(String value)? onDebounce;
  final bool small;
  final String? hintText;
  final String? initialValue;

  const RiverDebounceSearchBar({
    super.key,
    required StateProvider<String> this.provider,
    this.debounceDuration,
    this.controller,
    this.onChanged,
    this.onClear,
    this.onDebounce,
    this.small = false,
    this.hintText,
  })  : autoDisposeProvider = null,
        initialValue = null;

  const RiverDebounceSearchBar.autoDispose({
    super.key,
    required AutoDisposeStateProvider<String> provider,
    this.debounceDuration,
    this.controller,
    this.onChanged,
    this.onClear,
    this.onDebounce,
    this.small = false,
    this.hintText,
  })  : autoDisposeProvider = provider,
        provider = null,
        initialValue = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPattern = provider != null
        ? ref.watch(provider!)
        : ref.watch(autoDisposeProvider!);

    return DebounceSearchBar(
      debounceDuration: debounceDuration,
      controller: controller,
      onChanged: onChanged,
      onClear: () {
        if (provider != null) {
          ref.read(provider!.notifier).state = '';
        }
        if (autoDisposeProvider != null) {
          ref.read(autoDisposeProvider!.notifier).state = '';
        }
        onClear?.call();
      },
      onDebounce: (value) {
        if (provider != null) {
          ref.read(provider!.notifier).state = value.trim();
        }
        if (autoDisposeProvider != null) {
          ref.read(autoDisposeProvider!.notifier).state = value.trim();
        }
        onDebounce?.call(value);
      },
      small: small,
      hintText: hintText,
      initialValue: searchPattern,
    );
  }
}
