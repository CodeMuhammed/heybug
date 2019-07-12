import 'package:flutter/material.dart';
import 'package:heybug/widgets/empty.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  @override
  CustomImagePickerState createState() {
    return CustomImagePickerState();
  }
}

class CustomImagePickerState extends State<CustomImagePicker> {
  bool _savingImage = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _savingImage ? LinearProgressIndicator() : EmptyWidget(),
        ListTile(
          title: Text(
            'Update profile image',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.camera_alt),
          title: Text('Take a picture with camera'),
          onTap: () {
            _handleUpload(ImageSource.camera);
          },
        ),
        ListTile(
          trailing: Icon(Icons.photo_library),
          title: Text('Select from gallery'),
          onTap: () {
            _handleUpload(ImageSource.gallery);
          },
        ),
        Container(
          height: 40,
        )
      ],
    );
  }

  _handleUpload(ImageSource source) async {
    var image = await ImagePicker.pickImage(
      source: source,
    );

    if (image != null) {
      setState(() {
        _savingImage = true;
      });

      // here we handle the upload
    }
  }
}
