import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Mediaservice{

final ImagePicker _picker = ImagePicker(); //an instance of package

  Mediaservice(){}

  Future<File?> getImageFromGallery() async {
    final XFile? _file = await _picker.pickImage(source: ImageSource.gallery);

    if (_file != null) {
      return File(_file.path);
    }
    return null;
  }
}

//XFile is a class provided by the image_picker package.
//Once you have an XFile, you can access its path property.
// The File class from dart:io requires a file path to create an instance.