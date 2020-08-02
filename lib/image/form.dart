import 'dart:io';
import 'package:flutter/material.dart';
import 'tools.dart';

class ImgForm {
  String url;
  File file;
  bool deleted = false;
  bool editing = false;

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
            builder: (FormFieldState<ImgForm> field) => ImgFormWidget(field));
}

class ImgFormWidget extends StatelessWidget {
  final FormFieldState<ImgForm> state;
  ImgFormWidget(this.state);

  get form {
    return state.value;
  }

  change(Function applyChanges) {
    final value = form;
    applyChanges(value);
    state.didChange(value);
  }

  @override
  Widget build(BuildContext context) {
    if (form.url != null && !form.editing && !form.deleted) {
      return DisplayImage(
        url: form.url,
        onDelete: () => change((value) => form.deleted = true),
        onEdit: () => change((value) => value.editing = true),
      );
    }
    if (form.file == null) {
      return PickImage(
        onPicked: (img) => change((value) => value.file = img),
      );
    }
    return CropImage(
      file: form.file,
      onCancel: () => change((value) => value.file = null),
      onCropped: (img) => change((value) => value.file = img),
    );
  }
}
