import '../main.dart';
import '../models/AppSettingModel.dart';
import '../utils/Extensions/Commons.dart';
import 'BaseService.dart';

class AppSettingService extends BaseService {
  String? id;

  AppSettingService() {
    ref = db.collection('appSettings');
  }

  Future<AppSettingModel> getAppSettings() async {
    return await ref!.get().then((value) async {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;

        return AppSettingModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else{
        return AppSettingModel();
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<void> setAppSettings(AppSettingModel appSettingModel) async {
    await ref!.get().then((value) async {
      if (value.docs.isNotEmpty) {
        await updateDocument(appSettingModel.toJson(), id).then((value) {
          appStore.setLoading(false);
          toast(language.appSettingUpdated);
        }).catchError((e) {
          appStore.setLoading(false);
          throw e;
        });
      } else {
        await addDocument(appSettingModel.toJson()).then((value) {
          id = value.id;
          appStore.setLoading(false);
          toast(language.appSettingSaved);
        }).catchError((e) {
          appStore.setLoading(false);
          throw e;
        });
      }
    });
  }
}
