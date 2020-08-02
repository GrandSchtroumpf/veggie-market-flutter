import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

///////////////
/// DISPLAY ///
///////////////

class DisplayImage extends StatelessWidget {
  final String url;
  final Function onEdit;
  final Function onDelete;
  DisplayImage({this.url, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          url,
          width: 200.0,
          height: 200.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              child: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            FlatButton(
              child: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
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
  final Function onPicked;
  PickImage({this.onPicked});

  _pick(ImageSource source) async {
    PickedFile file = await imgPicker.getImage(source: source);
    if (file != null) {
      onPicked(File(file.path));
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

////////////
/// CROP ///
////////////

class CropImage extends StatelessWidget {
  final File file;
  final Function onCropped;
  final Function onCancel;
  CropImage({this.file, this.onCropped, this.onCancel});

  _crop() async {
    File img = await ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      maxWidth: 512,
      maxHeight: 512,
    );
    onCropped(img);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.file(
          file,
          width: 200.0,
          height: 200.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              child: Icon(Icons.crop),
              onPressed: _crop,
            ),
            FlatButton(
              child: Icon(Icons.refresh),
              onPressed: onCancel,
            ),
          ],
        ),
      ],
    );
  }
}
