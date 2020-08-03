import 'dart:io';
import 'package:flutter/material.dart';
import 'tools.dart';

class ImgForm {
  String url;
  File file;

  ImgForm(this.url);
}

class ImgFormField extends FormField<ImgForm> {
  ImgFormField({
    FormFieldSetter<ImgForm> onSaved,
    FormFieldValidator<ImgForm> validator,
    ImgForm initialValue,
    bool autovalidate = false,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            builder: (FormFieldState<ImgForm> state) => ImgFormWidget(state));
}

class ImgFormWidget extends StatelessWidget {
  final FormFieldState<ImgForm> state;
  ImgFormWidget(this.state);

  @override
  Widget build(BuildContext context) {
    final form = state.value;
    if (form.url != null || form.file != null) {
      return DisplayImage(
        url: form.url,
        file: form.file,
        onEdit: () {
          form.url = null;
          form.file = null;
          state.didChange(form);
        },
      );
    } else {
      return PickImage(
        onPicked: (File img) {
          form.file = img;
          state.didChange(form);
        },
      );
    }
  }
}
