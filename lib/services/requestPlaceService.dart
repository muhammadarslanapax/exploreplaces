import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/Extensions/shared_pref.dart';
import '../main.dart';
import '../models/PlaceModel.dart';
import '../utils/AppConstant.dart';
import '../utils/ModelKeys.dart';
import 'BaseService.dart';

class RequestPlaceService extends BaseService {
  RequestPlaceService() {
    ref = db.collection('requestPlaces');
  }

  Future<List<PlaceModel>> fetchRequestPlaceList({required List<PlaceModel> list}) async {
    Query query;
    QuerySnapshot querySnapshot;

    query = ref!.where(PlaceKeys.userId,isEqualTo: getStringAsync(USER_ID)).orderBy(CommonKeys.createdAt, descending: true);

    if (list.isEmpty) {
      querySnapshot = await query.limit(perPageLimit).get();
    } else {
      querySnapshot = await query.startAfterDocument(await ref!.doc(list[list.length - 1].id).get()).limit(perPageLimit).get();
    }

    List<PlaceModel> data = querySnapshot.docs.map((e) => PlaceModel.fromJson(e.data() as Map<String, dynamic>)).toList();

    return data;
  }
}
