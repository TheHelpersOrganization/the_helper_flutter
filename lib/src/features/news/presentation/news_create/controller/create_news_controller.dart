import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quillControllerProvider =
    Provider.autoDispose((ref) => QuillController.basic());
