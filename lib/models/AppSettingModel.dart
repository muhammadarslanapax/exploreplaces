class AppSettingModel {
  String? contactUs;
  String? helpAndSupport;
  String? privacyPolicy;
  String? purchase;
  String? rateUs;
  String? termAndConditions;
  bool? isAdsEnable;
  bool? isNotificationOn;
  String? adsType;
  Admob? admob;
  num? nearByPlacesDistance;

  AppSettingModel({
    this.contactUs,
    this.helpAndSupport,
    this.privacyPolicy,
    this.purchase,
    this.rateUs,
    this.termAndConditions,
    this.isAdsEnable,
    this.isNotificationOn,
    this.adsType,
    this.admob,
    this.nearByPlacesDistance,
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) {
    return AppSettingModel(
      contactUs: json['contactUs'],
      helpAndSupport: json['helpAndSupport'],
      privacyPolicy: json['privacyPolicy'],
      purchase: json['purchase'],
      rateUs: json['rateUs'],
      termAndConditions: json['termAndConditions'],
      isAdsEnable: json['isAdsEnable'],
      isNotificationOn: json['isNotificationOn'],
      adsType: json['adsType'],
      admob: json['admob'] != null ? Admob.fromJson(json['admob']) : null,
      nearByPlacesDistance: json['nearByPlacesDistance'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactUs'] = this.contactUs;
    data['helpAndSupport'] = this.helpAndSupport;
    data['privacyPolicy'] = this.privacyPolicy;
    data['purchase'] = this.purchase;
    data['rateUs'] = this.rateUs;
    data['termAndConditions'] = this.termAndConditions;
    data['isAdsEnable'] = this.isAdsEnable;
    data['isNotificationOn'] = this.isNotificationOn;
    data['adsType'] = this.adsType;
    if (this.admob != null) {
      data['admob'] = this.admob!.toJson();
    }
    data['nearByPlacesDistance'] = this.nearByPlacesDistance;
    return data;
  }
}

class Admob {
  String? bannerId;
  String? bannerIdIos;
  String? interstitialId;
  String? interstitialIdIos;
  String? rewardedId;
  String? rewardedIdIos;

  Admob({
    this.bannerId,
    this.bannerIdIos,
    this.interstitialId,
    this.interstitialIdIos,
    this.rewardedId,
    this.rewardedIdIos,
  });

  factory Admob.fromJson(Map<String, dynamic> json) {
    return Admob(
      bannerId: json['bannerId'],
      bannerIdIos: json['bannerIdIos'],
      interstitialId: json['interstitialId'],
      interstitialIdIos: json['interstitialIdIos'],
      rewardedId: json['rewardedId'],
      rewardedIdIos: json['rewardedIdIos'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bannerId'] = this.bannerId;
    data['bannerIdIos'] = this.bannerIdIos;
    data['interstitialId'] = this.interstitialId;
    data['interstitialIdIos'] = this.interstitialIdIos;
    data['rewardedId'] = this.rewardedId;
    data['rewardedIdIos'] = this.rewardedIdIos;
    return data;
  }
}
