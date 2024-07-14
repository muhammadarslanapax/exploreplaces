import 'dart:convert';
import '../components/AdmobAdComponent.dart';

import '../components/FacebookAdComponent.dart';
import '../models/PlaceModel.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/LiveStream.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/ModelKeys.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../language/AppLocalizations.dart';
import '../language/BaseLanguage.dart';
import '../main.dart';
import '../models/LanguageDataModel.dart';
import '../screens/LogInScreen.dart';
import '../utils/AppConstant.dart';
import '../utils/Common.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/shared_pref.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  bool isDarkMode = false;

  @observable
  String selectedLanguage = "";

  @observable
  String profileImg = '';

  @observable
  List<String> favouriteList = ObservableList<String>();

  @observable
  bool isLoading = false;

  @observable
  String selectedPlaceId = '';

  @action
  Future<void> setLoggedIn(bool val) async {
    isLoggedIn = val;
    await setValue(IS_LOGGED_IN, val);
    LiveStream().emit('UpdateLoginScreen');
  }

  @action
  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkMode = aIsDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;

      shadowColorGlobal = Colors.white12;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.black12;
    }
  }

  @action
  Future<void> addRemoveFavouriteData(BuildContext context,String id) async {
    if (isLoggedIn) {
      if (isItemInFavourite(id)) {
        removeFavourite(id);
      } else {
        if(rewardedAd!=null || isRewardedAdLoaded) {
          showRewardedAds(onAdCompleted: () {
            addFavourite(id);
          });
        }else{
          addFavourite(id);
        }
      }
    } else {
      LoginScreen().launch(context);
    }
  }

  Future<void> addFavourite(String id) async {
    int favoritesCount = 0;
    favoritesCount = await placeService.documentByIdFuture(id).then((value) => PlaceModel.fromJson(value.data() as Map<String,dynamic>).favourites.validate(value: 0));
    favouriteList.add(id);
    favoritesCount += 1;
    toast("added");
    setFavouriteData();
    await userService.updateDocument({UserKeys.favouritePlacesList: favouriteList}, getStringAsync(USER_ID));
    await placeService.updateDocument({PlaceKeys.favourites : favoritesCount}, id);
  }

  Future<void> removeFavourite(String id) async {
    int favoritesCount = 0;
    favoritesCount = await placeService.documentByIdFuture(id).then((value) => PlaceModel.fromJson(value.data() as Map<String,dynamic>).favourites.validate(value: 0));
    favouriteList.remove(id);
    if(favoritesCount > 0) {
      favoritesCount = favoritesCount -= 1;
    }
    toast("remove");
    setFavouriteData();
    await userService.updateDocument({UserKeys.favouritePlacesList: favouriteList}, getStringAsync(USER_ID));
    await placeService.updateDocument({PlaceKeys.favourites : favoritesCount}, id);
  }

  @action
  Future<void> setFavouriteData() async {
    if (favouriteList.isNotEmpty) {
      await setValue(FAVOURITE_LIST, jsonEncode(favouriteList));
    } else {
      await setValue(FAVOURITE_LIST, '');
    }
  }

  @action
  void addAllFavouriteItem(List<String> favList) {
    favouriteList.addAll(favList);
  }

  bool isItemInFavourite(String id) {
    return favouriteList.any((elementId) => elementId == id);
  }

  @action
  Future<void> setLanguage(String aCode, {BuildContext? context}) async {
    selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: defaultLanguage);
    selectedLanguage = getSelectedLanguageModel(defaultLanguage: defaultLanguage)!.languageCode!;

    if (context != null) language = BaseLanguage.of(context)!;
    language = await AppLocalizations().load(Locale(selectedLanguage));
  }

  @action
  void setProfileImg(String image) {
    profileImg = image;
  }

  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setSelectedPlaceId(String val) {
    selectedPlaceId = val;
  }
}
