import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../utils/AppConstant.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';

Future<String> uploadFile({Uint8List? bytes, dynamic blob, File? file, String prefix = mFirebaseStorageFilePath}) async {
  if (blob == null && file == null && bytes == null) {
    throw errorSomethingWentWrong;
  }

  if (prefix.isNotEmpty && !prefix.endsWith('/')) {
    prefix = '$prefix';
  }
  String fileName = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
  if (file != null) {
    fileName = '${path.basename(file.path)}';
  }

  Reference storageReference = FirebaseStorage.instance.ref(prefix).child('$fileName.png');

  log(storageReference.fullPath);

  UploadTask? uploadTask;

  if (file != null) {
    uploadTask = storageReference.putFile(file);
  } else if (blob != null) {
    uploadTask = storageReference.putBlob(blob);
  } else if (bytes != null) {
    uploadTask = storageReference.putData(bytes, SettableMetadata(contentType: 'image/png'));
  }

  if (uploadTask == null) throw errorSomethingWentWrong;

  log('File Uploading');

  return await uploadTask.then(
    (v) async {
      log('File Uploaded');

      if (v.state == TaskState.success) {
        String url = await storageReference.getDownloadURL();

        log('url:$url');

        return url;
      } else {
        throw errorSomethingWentWrong;
      }
    },
  ).catchError(
    (error) {
      throw error;
    },
  );
}

Future<void> deleteFile(String url, {String? prefix = mFirebaseStorageFilePath}) async {
  String reg = 'https://firebasestorage.googleapis.com/v0/b/$mStorageBucket/o/$prefix%2F';
  String path = url.replaceAll(RegExp(reg), '').split('?')[0];
  await FirebaseStorage.instance.ref().child('$prefix/$path').delete().then(
    (value) {
      log('File deleted: $url');
    },
  ).catchError(
    (e) {
      throw e;
    },
  );
}

Future<List<String>> listOfFileFromFirebaseStorage({String? path}) async {
  List<String> list = [];

  var ref = FirebaseStorage.instance.ref(mFirebaseStorageFilePath);
  log(ref);

  var listResult = await ref.listAll();
  log(listResult);

  listResult.prefixes.forEach(
    (element) {
      log(element.fullPath);
    },
  );
  listResult.items.forEach(
    (element) {
      log(element.fullPath);

      list.add(element.fullPath);
    },
  );
  return list;
}
