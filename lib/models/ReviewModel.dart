import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/ModelKeys.dart';

class ReviewModel {
  String? id;
  String? comment;
  String? placeId;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? rating;

  ReviewModel({this.comment, this.createdAt, this.id, this.placeId, this.updatedAt, this.userId,this.rating});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      comment: json[ReviewKeys.comment],
      id: json[CommonKeys.id],
      placeId: json[ReviewKeys.placeId],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      userId: json[ReviewKeys.userId],
      rating: json[ReviewKeys.rating]
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[ReviewKeys.comment] = this.comment;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.id] = this.id;
    data[ReviewKeys.placeId] = this.placeId;
    data[ReviewKeys.updatedAt] = this.updatedAt;
    data[ReviewKeys.userId] = this.userId;
    data[ReviewKeys.rating] = this.rating;
    return data;
  }
}
