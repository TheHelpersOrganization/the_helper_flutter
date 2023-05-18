import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(controllerProvider);

    return Scaffold(
      body: Column(
        children: [
          const Text('This part should not be grayed out'),
          FilledButton(
            onPressed: () {},
            child: const Text('Clickable'),
          ),
          const Divider(),
          Expanded(
            child: LoadingOverlay(
              isLoading: state.isLoading,
              child: Column(
                children: [
                  TextButton(onPressed: () {}, child: const Text('Hello')),
                  const Text('adsfsdfsdfdsfs'),
                  Expanded(
                    child: Center(
                      child: FilledButton(
                        child: const Text('Click'),
                        onPressed: () {
                          ref.read(controllerProvider.notifier).test();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Controller extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> test() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 5));
    state = const AsyncData(null);
  }
}

final controllerProvider = AutoDisposeAsyncNotifierProvider(
  () => Controller(),
);
