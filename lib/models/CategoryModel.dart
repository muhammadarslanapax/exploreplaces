import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/ModelKeys.dart';

class CategoryModel {
  String? id;
  String? name;
  String? image;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[CommonKeys.id],
      name: json[CategoryKeys.name],
      image: json[CategoryKeys.image],
      status: json[CommonKeys.status],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[CategoryKeys.name] = this.name;
    data[CategoryKeys.image] = this.image;
    data[CommonKeys.status] = this.status;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    return data;
  }
}
