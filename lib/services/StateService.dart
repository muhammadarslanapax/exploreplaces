import '../main.dart';
import '../models/StateModel.dart';
import '../utils/ModelKeys.dart';
import 'BaseService.dart';

class StateService extends BaseService {
  StateService() {
    ref = db.collection('state');
  }

  Future<List<StateModel>> getStatesFuture() async{
    return ref!.where(CommonKeys.status,isEqualTo: 1).orderBy(CommonKeys.createdAt,descending: true).get().then((value) => value.docs.map((e) => StateModel.fromJson(e.data() as Map<String,dynamic>)).toList());
  }

  Stream<List<StateModel>> getStates(){
    return ref!.where(CommonKeys.status,isEqualTo: 1).orderBy(CommonKeys.createdAt,descending: true).snapshots().map((value) => value.docs.map((e) => StateModel.fromJson(e.data() as Map<String,dynamic>)).toList());
  }
}
