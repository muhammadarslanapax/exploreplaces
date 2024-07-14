import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage? of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage);

  String get appName;

  String get selectLanguage;

  String get explore;

  String get cancel;

  String get ok;

  String get writeAReview;

  String get whatIsYourRate;

  String get rateSubtext;

  String get yourReview;

  String get sendReview;

  String get appTheme;

  String get aboutUs;

  String get contactUs;

  String get purchase;

  String get noItemsInFavourite;

  String get category;

  String get changePassword;

  String get oldPassword;

  String get newPassword;

  String get confirmPassword;

  String get passwordNotMatch;

  String get favourite;

  String get settings;

  String get upload;

  String get name;

  String get contactNo;

  String get email;

  String get youCannotChangeIt;

  String get editProfile;

  String get forgotPassword;

  String get forgotPasswordText;

  String get submit;

  String get viewAll;

  String get nearByPlaces;

  String get popularPlaces;

  String get signIn;

  String get signInText;

  String get password;

  String get rememberMe;

  String get forgotPasswordQue;

  String get doNotHaveAnAccount;

  String get signUp;

  String get history;

  String get gallery;

  String get video;

  String get review;

  String get signUpText;

  String get alreadyHaveAnAccount;

  String get searchPlaces;

  String get generalSetting;

  String get appLanguage;

  String get rateUs;

  String get others;

  String get privacyPolicy;

  String get termsAndConditions;

  String get helpAndSupport;

  String get skip;

  String get next;

  String get finish;

  String get light;

  String get dark;

  String get systemDefault;

  String get pleaseFillRating;

  String get pleaseWriteReview;

  String get passwordChanged;

  String get resetPasswordSentTo;

  String get noUserFound;

  String get latestPlaces;

  String get logout;

  String get areYouSure;

  String get logoutConfirmation;

  String get no;

  String get yes;

  String get appSettingUpdated;

  String get appSettingSaved;

  String get orSignInWith;

  String get signInWithGoogle;

  String get deleteAccount;

  String get somethingWentWrong;

  String get noDataFound;

  String get deleteAccountMsg;

  String get deletePlaceRequestMsg;

  String get placeUpdated;

  String get placeAdded;

  String get requestNewPlace;

  String get placeName;

  String get state;

  String get placeAddress;

  String get description;

  String get primaryImage;

  String get browse;

  String get clear;

  String get secondaryImages;

  String get save;

  String get enterValidAddress;

  String get selectPrimaryImage;

  String get states;

  String get pickPlace;

  String get findAPlace;

  String get pleaseWait;

  String get selectPlace;

  String get placeNotInArea;

  String get placesRequest;

  String get addPlace;

  String get enableLocationMsg;

  String get locationDeniedMsg;

  String get locationDeniedForever;

  String get signInWithApple;
}
