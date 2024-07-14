import '../main.dart';
import '../models/CategoryModel.dart';
import '../utils/AppConstant.dart';
import '../utils/ModelKeys.dart';
import 'BaseService.dart';

class CategoryService extends BaseService {
  CategoryService() {
    ref = db.collection('category');
  }

  Future<List<CategoryModel>> getCategoriesFuture() async {
    return ref!.where(CommonKeys.status,isEqualTo: 1).orderBy(CommonKeys.createdAt,descending: true).get().then((value) => value.docs.map((e) => CategoryModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }

  Future<List<CategoryModel>> getCategories({bool isViewAll = true}) {
    if(isViewAll) {
      return ref!.where(CommonKeys.status,isEqualTo: 1).orderBy(CommonKeys.createdAt, descending: true).get().then((value) => value.docs.map((e) => CategoryModel.fromJson(e.data() as Map<String, dynamic>)).toList());
    }else{
      return ref!.where(CommonKeys.status,isEqualTo: 1).orderBy(CommonKeys.createdAt, descending: true).limit(homeCategoryLimit).get().then((value) => value.docs.map((e) => CategoryModel.fromJson(e.data() as Map<String, dynamic>)).toList());
    }
  }
}
