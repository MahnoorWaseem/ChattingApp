import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService() {}

  Future<String?> uploadUserPfp({
    required File file,
    required String uid,
  }) async {
    Reference fileRef = _firebaseStorage
        .ref('user/pfps')
        .child('$uid${p.extension(file.path)}');

    //now after creating folder of that usr we will uplaod its pfp (file)in its respcive folder(fileRef)

    UploadTask task = fileRef.putFile(file);
    return task.then(
      (p) {
        if (p.state  == TaskState.success) {
          return fileRef.getDownloadURL(); //if upload task is completed then it will return a downloadable link othrwis null
        }
      },
    );
  }
}
