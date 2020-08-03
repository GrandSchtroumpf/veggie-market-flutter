import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

///////////////
/// DISPLAY ///
///////////////

class DisplayImage extends StatelessWidget {
  final String url;
  final File file;
  final Function onEdit;
  DisplayImage({this.url, this.file, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: url != null ? NetworkImage(url) : FileImage(file),
          width: 200.0,
          height: 200.0,
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ],
    );
  }
}

////////////
/// PICK ///
////////////

class PickImage extends StatelessWidget {
  final imgPicker = ImagePicker();
  final Function(File) onPicked;
  PickImage({this.onPicked});

  _pick(ImageSource source) async {
    PickedFile file = await imgPicker.getImage(source: source);
    if (file != null) {
      File img = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        maxWidth: 512,
        maxHeight: 512,
      );
      if (img != null) {
        onPicked(File(img.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          heightFactor: 5.0,
          child: Text('Pick an image or use Camera'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pick(ImageSource.gallery),
            ),
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pick(ImageSource.camera),
            ),
          ],
        ),
      ],
    );
  }
}
