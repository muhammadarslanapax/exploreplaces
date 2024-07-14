import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/Extensions/Widget_extensions.dart';
import '../utils/ModelKeys.dart';

abstract class BaseService {
  CollectionReference? ref;

  BaseService({this.ref});

  Future<DocumentReference> addDocument(Map data) async {
    return await ref!.add(data).then((value) {
      value.update({CommonKeys.id: value.id});

      log('Added: $data');

      return value;
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Future<DocumentReference> addDocumentWithCustomId(String id, Map data) async {
    var doc = ref!.doc(id);

    return await doc.set(data).then((value) {
      log('Added: $data');

      return doc;
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Stream<DocumentSnapshot> documentById(String id) {
    var doc = ref!.doc(id);

    return doc.snapshots();
  }

  Future<DocumentSnapshot> documentByIdFuture(String id) {
    var doc = ref!.doc(id);

    return doc.get();
  }

  Future<void> updateDocument(Map<String, dynamic> data, String? id) async {
    await ref!.doc(id).update(data).then((value) {
      log('Updated: $data');
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Future<void> removeDocument(String? id) async {
    await ref!.doc(id).delete().then((value) {
      log('Removed: $id');
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Future<bool> isExists(String field, value) async {
    Query query = ref!.limit(1).where(field, isEqualTo: value);

    var res = await query.get();

    return res.docs.length == 1;
  }
}
