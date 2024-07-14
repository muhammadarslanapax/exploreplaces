// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  late final _$isLoggedInAtom =
      Atom(name: '_AppStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$isDarkModeAtom =
      Atom(name: '_AppStore.isDarkMode', context: context);

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  late final _$selectedLanguageAtom =
      Atom(name: '_AppStore.selectedLanguage', context: context);

  @override
  String get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(String value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  late final _$profileImgAtom =
      Atom(name: '_AppStore.profileImg', context: context);

  @override
  String get profileImg {
    _$profileImgAtom.reportRead();
    return super.profileImg;
  }

  @override
  set profileImg(String value) {
    _$profileImgAtom.reportWrite(value, super.profileImg, () {
      super.profileImg = value;
    });
  }

  late final _$favouriteListAtom =
      Atom(name: '_AppStore.favouriteList', context: context);

  @override
  List<String> get favouriteList {
    _$favouriteListAtom.reportRead();
    return super.favouriteList;
  }

  @override
  set favouriteList(List<String> value) {
    _$favouriteListAtom.reportWrite(value, super.favouriteList, () {
      super.favouriteList = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AppStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$selectedPlaceIdAtom =
      Atom(name: '_AppStore.selectedPlaceId', context: context);

  @override
  String get selectedPlaceId {
    _$selectedPlaceIdAtom.reportRead();
    return super.selectedPlaceId;
  }

  @override
  set selectedPlaceId(String value) {
    _$selectedPlaceIdAtom.reportWrite(value, super.selectedPlaceId, () {
      super.selectedPlaceId = value;
    });
  }

  late final _$setLoggedInAsyncAction =
      AsyncAction('_AppStore.setLoggedIn', context: context);

  @override
  Future<void> setLoggedIn(bool val) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(val));
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('_AppStore.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  late final _$addRemoveFavouriteDataAsyncAction =
      AsyncAction('_AppStore.addRemoveFavouriteData', context: context);

  @override
  Future<void> addRemoveFavouriteData(BuildContext context, String id) {
    return _$addRemoveFavouriteDataAsyncAction
        .run(() => super.addRemoveFavouriteData(context, id));
  }

  late final _$setFavouriteDataAsyncAction =
      AsyncAction('_AppStore.setFavouriteData', context: context);

  @override
  Future<void> setFavouriteData() {
    return _$setFavouriteDataAsyncAction.run(() => super.setFavouriteData());
  }

  late final _$setLanguageAsyncAction =
      AsyncAction('_AppStore.setLanguage', context: context);

  @override
  Future<void> setLanguage(String aCode, {BuildContext? context}) {
    return _$setLanguageAsyncAction
        .run(() => super.setLanguage(aCode, context: context));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void addAllFavouriteItem(List<String> favList) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.addAllFavouriteItem');
    try {
      return super.addAllFavouriteItem(favList);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProfileImg(String image) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setProfileImg');
    try {
      return super.setProfileImg(image);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedPlaceId(String val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setSelectedPlaceId');
    try {
      return super.setSelectedPlaceId(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isDarkMode: ${isDarkMode},
selectedLanguage: ${selectedLanguage},
profileImg: ${profileImg},
favouriteList: ${favouriteList},
isLoading: ${isLoading},
selectedPlaceId: ${selectedPlaceId}
    ''';
  }
}
