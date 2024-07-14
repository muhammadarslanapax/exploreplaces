import '../models/CategoryModel.dart';

import '../utils/ModelKeys.dart';
import 'PlaceModel.dart';

class DashboardResponse {
  List<CategoryPlaceModel>? categoryPlaces;
  List<PlaceModel>? latestPlaces;
  List<PlaceModel>? popularPlaces;
  List<PlaceModel>? nearByPlaces;

  DashboardResponse({
    this.categoryPlaces,
    this.latestPlaces,
    this.popularPlaces,
    this.nearByPlaces,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      categoryPlaces: json[DashboardKeys.categoryPlaces]!=null ? (json[DashboardKeys.categoryPlaces] as List).map((i) => CategoryPlaceModel.fromJson(i)).toList() : null,
      latestPlaces: json[DashboardKeys.latestPlaces] != null ? (json[DashboardKeys.latestPlaces] as List).map((i) => PlaceModel.fromJson(i)).toList() : null,
      popularPlaces: json[DashboardKeys.popularPlaces] != null ? (json[DashboardKeys.popularPlaces] as List).map((i) => PlaceModel.fromJson(i)).toList() : null,
      nearByPlaces: json[DashboardKeys.nearByPlaces] != null ? (json[DashboardKeys.nearByPlaces] as List).map((i) => PlaceModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson({bool toStore = true}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryPlaces != null) {
      data[DashboardKeys.categoryPlaces] = this.categoryPlaces!.map((v) => v.toJson()).toList();
    }
    if (this.latestPlaces != null) {
      data[DashboardKeys.latestPlaces] = this.latestPlaces!.map((v) => v.toJson()).toList();
    }
    if (this.popularPlaces != null) {
      data[DashboardKeys.popularPlaces] = this.popularPlaces!.map((v) => v.toJson()).toList();
    }
    if (this.nearByPlaces != null) {
      data[DashboardKeys.nearByPlaces] = this.nearByPlaces!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryPlaceModel{
  CategoryModel? category;
  List<PlaceModel>? places;

  CategoryPlaceModel({this.category, this.places});

  factory CategoryPlaceModel.fromJson(Map<String, dynamic> json) {
    return CategoryPlaceModel(
      category: json[DashboardKeys.category] != null ? CategoryModel.fromJson(json[DashboardKeys.category]) : null,
      places: json[DashboardKeys.places] != null ? (json[DashboardKeys.places] as List).map((i) => PlaceModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson({bool toStore = true}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data[DashboardKeys.category] = this.category!.toJson();
    }
    if (this.places != null) {
      data[DashboardKeys.places] = this.places!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}