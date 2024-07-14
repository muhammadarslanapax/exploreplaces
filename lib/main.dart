import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/AppSettingService.dart';
import '../services/CategoryService.dart';
import '../services/PlaceService.dart';
import '../services/ReviewServices.dart';
import '../services/StateService.dart';
import '../services/UserService.dart';
import '../services/requestPlaceService.dart';
import '../store/AppStore.dart';
import '../utils/Common.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../screens/SplashScreen.dart';
import '../utils/AppColor.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/Commons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppTheme.dart';
import 'language/AppLocalizations.dart';
import 'language/BaseLanguage.dart';
import 'models/LanguageDataModel.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

FirebaseAuth auth = FirebaseAuth.instance;

late SharedPreferences sharedPreferences;
AppStore appStore = AppStore();
late BaseLanguage language;
Color defaultLoaderBgColorGlobal = Colors.white;
Color? defaultLoaderAccentColorGlobal = primaryColor;
final navigatorKey = GlobalKey<NavigatorState>();

int passwordLengthGlobal = 6;
List<LanguageDataModel> localeLanguageList = [];
LanguageDataModel? selectedLanguageDataModel;

CategoryService categoryService = CategoryService();
PlaceService placeService = PlaceService();
StateService stateService = StateService();
ReviewService reviewService = ReviewService();
UserService userService = UserService();
AppSettingService appSettingService = AppSettingService();
RequestPlaceService requestPlaceService = RequestPlaceService();

Future<void> initialize({
  double? defaultDialogBorderRadius,
  List<LanguageDataModel>? aLocaleLanguageList,
  String? defaultLanguage,
}) async {
  sharedPreferences = await SharedPreferences.getInstance();
  localeLanguageList = aLocaleLanguageList ?? [];
  selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: defaultLanguage);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    MobileAds.instance.initialize();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  });
  sharedPreferences = await SharedPreferences.getInstance();

  await initialize(aLocaleLanguageList: languageList());

  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
  appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage));
  appStore.setProfileImg(getStringAsync(USER_PROFILE));
  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == appThemeMode.themeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == appThemeMode.themeModeDark) {
    appStore.setDarkMode(true);
  }

  String favouriteString = getStringAsync(FAVOURITE_LIST);
  if (favouriteString.isNotEmpty) {
    appStore.addAllFavouriteItem(jsonDecode(favouriteString).map<String>((e) => e.toString()).toList());
  }

  await appSettingService.getAppSettings().then((value) {
    setValue(CONTACT_US, value.contactUs.validate());
    setValue(HELP_AND_SUPPORT, value.helpAndSupport.validate());
    setValue(PRIVACY_POLICY, value.privacyPolicy.validate());
    setValue(PURCHASE, value.purchase.validate());
    setValue(RATE_US, value.rateUs.validate());
    setValue(TERM_AND_CONDITIONS, value.termAndConditions.validate());
    setValue(IS_ADS_ENABLE, value.isAdsEnable.validate(value: defaultIsAdsEnable));
    setValue(IS_NOTIFICATION_ON, value.isNotificationOn.validate(value: defaultIsNotificationOn));
    setValue(ADS_TYPE, value.adsType.validate(value: defaultAdsType));
    setValue(NEAR_BY_PLACE_DISTANCE, double.parse((value.nearByPlacesDistance ?? nearByPlaceDistanceKm).toString()));
    if (value.admob != null) {
      setValue(BANNER_ID, value.admob!.bannerId.validate());
      setValue(BANNER_ID_IOS, value.admob!.bannerIdIos.validate());
      setValue(INTERSTITIAL_ID, value.admob!.interstitialId.validate());
      setValue(INTERSTITIAL_ID_IOS, value.admob!.interstitialIdIos.validate());
      setValue(REWARDED_ID, value.admob!.rewardedId.validate());
      setValue(REWARDED_ID_IOS, value.admob!.rewardedIdIos.validate());
    }
  });

  await OneSignal.shared.setAppId(mOneSignalAppId);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          title: appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          scrollBehavior: SBehavior(),
          supportedLocales: LanguageDataModel.languageLocales(),
          localizationsDelegates: [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => locale,
          locale: Locale(appStore.selectedLanguage.validate(value: DEFAULT_LANGUAGE)),
        );
      },
    );
  }
}
