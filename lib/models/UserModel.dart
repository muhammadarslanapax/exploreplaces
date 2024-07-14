import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/ModelKeys.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? contactNo;
  String? profileImg;
  String? loginType;
  bool? isAdmin;
  bool? isDemoAdmin;
  List<String>? favouritePlacesList;
  String? fcmToken;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.contactNo,
    this.profileImg,
    this.loginType,
    this.isAdmin,
    this.isDemoAdmin,
    this.favouritePlacesList,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json[CommonKeys.id];
    name = json[UserKeys.name];
    email = json[UserKeys.email];
    contactNo = json[UserKeys.contactNo];
    profileImg = json[UserKeys.profileImg];
    loginType = json[UserKeys.loginType];
    isAdmin = json[UserKeys.isAdmin];
    isDemoAdmin = json[UserKeys.isDemoAdmin];
    favouritePlacesList = json[UserKeys.favouritePlacesList]!=null ? List<String>.from(json[UserKeys.favouritePlacesList]) : null;
    fcmToken = json[UserKeys.fcmToken];
    createdAt = json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null;
    updatedAt = json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[UserKeys.name] = this.name;
    data[UserKeys.email] = this.email;
    data[UserKeys.contactNo] = this.contactNo;
    data[UserKeys.profileImg] = this.profileImg;
    data[UserKeys.loginType] = this.loginType;
    data[UserKeys.isAdmin] = this.isAdmin;
    data[UserKeys.isDemoAdmin] = this.isDemoAdmin;
    if (this.favouritePlacesList != null) {
      data[UserKeys.favouritePlacesList] = this.favouritePlacesList;
    }
    data[UserKeys.fcmToken] = this.fcmToken;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    return data;
  }
}
