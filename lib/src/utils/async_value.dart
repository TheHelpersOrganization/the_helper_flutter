import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';

Future<AsyncValue<T>> guardAsyncValue<T>(FutureOr<T> Function() future) async {
  try {
    return AsyncValue.data(await future());
  } on BackendException catch (ex, st) {
    return AsyncValue.error(ex.error.message, st);
  } catch (err, stack) {
    print(stack);
    print(err);
    return AsyncValue.error('An error has happened', stack);
  }
}
