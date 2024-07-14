import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../models/UserModel.dart';
import '../utils/AppConstant.dart';
import '../utils/ModelKeys.dart';
import 'BaseService.dart';

class UserService extends BaseService{
  UserService(){
    ref = db.collection('users');
  }

  Future<List<UserModel>> getUsers(){
    return ref!.get().then((event) => event.docs.map((e) => UserModel.fromJson(e.data() as Map<String,dynamic>)).toList());
  }

  Future<bool> isUserExist(String? email, String loginType) async {
    Query query = ref!.limit(1).where(UserKeys.loginType, isEqualTo: loginType).where(UserKeys.email, isEqualTo: email);

    var res = await query.get();

    return res.docs.length == 1;
  }

  Future<UserModel> userByEmail(String? email) async {
    return await ref!.where(UserKeys.email, isEqualTo: email).limit(1).get().then((value) {
      if (value.docs.isNotEmpty) {
        return UserModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw language.noUserFound;
      }
    });
  }

  Future<List<UserModel>> fetchUsersList({required List<UserModel> list}) async {
    QuerySnapshot querySnapshot;
    List<UserModel> filterList = [];

    if (list.isEmpty) {
      querySnapshot = await ref!
          .orderBy(CommonKeys.createdAt, descending: true)
          .limit(perPageLimit)
          .get();
    } else {
      querySnapshot = await ref!
          .orderBy(CommonKeys.createdAt, descending: true)
          .startAfter([list[list.length - 1].createdAt])
          .limit(perPageLimit)
          .get();
    }

    List<UserModel> data = querySnapshot.docs.map((e) => UserModel.fromJson(e.data() as Map<String,dynamic>)).toList();

    /// Eliminate duplicate data
    for (int i = 0; i < data.length; i++) {
      if (!list.any((element) => element.id == data[i].id)) {
        filterList.add(data[i]);
      }
    }

    return filterList;
  }

  Stream<int> totalUsers() {
    return ref!.snapshots().map((x) => x.docs.length);
  }
}