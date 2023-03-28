import 'package:file_picker/file_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:the_helper/src/common/widget/file_picker/multiple_file_picker.dart';

class FormMultipleFilePickerField extends FormBuilderField<List<PlatformFile>> {
  FormMultipleFilePickerField({super.key, required super.name})
      : super(
          builder: (state) {
            return MultipleFilesPickerWidget(
              onChanged: (files) => state.didChange(files),
            );
          },
        );
}
