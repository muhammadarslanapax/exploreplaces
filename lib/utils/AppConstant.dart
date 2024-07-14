const appName = "Explore Places";

/// one signal Key
const mOneSignalAppId = 'ADD_YOUR_ONE_SIGNAL_APP_ID';

/// Google Map key
const googleMapApiKey = 'ADD_YOUR_GOOGLE_MAP_KEY';

/// storage bucket
const mStorageBucket = 'ADD_YOUR_STORAGE_BUCKET';

/// Server Key
const serverKey  = "ADD_SERVER_KEY";

/// Storage Folder
const mFirebaseStorageFilePath = 'images';
const mPlacesStoragePath = 'PlaceImages';
const mProfileStoragePath = 'userProfile';

/// Max Kilometer distance for near by places
double nearByPlaceDistanceKm = 50;

int perPageLimit = 10;
int homeCategoryLimit = 10;
int homePlaceLimit = 10;

const HOME_INDEX = 0;
const CATEGORY_INDEX = 1;
const STATE_INDEX = 2;
const FAVOURITE_INDEX = 3;
const SETTING_INDEX = 4;

AppThemeMode appThemeMode = AppThemeMode();

class AppThemeMode {
  final int themeModeLight = 1;
  final int themeModeDark = 2;
  final int themeModeSystem = 0;
}

const placesTypePopular = 'placesTypePopular';
const placesTypeNearBy = 'placesTypeNearBy';

/// Ads type
String isGoogleAds = "admob";
String isFacebookAds = "facebook";

bool defaultIsAdsEnable = true;
bool defaultIsNotificationOn = true;
String defaultAdsType = isFacebookAds;

//AdmobId
const adMobBannerId = "ca-app-pub-3940256099942544/6300978111";
const adMobInterstitialId = "ca-app-pub-3940256099942544/1033173712";
const adMobBannerIdIos = "ca-app-pub-3940256099942544/2934735716";
const adMobInterstitialIdIos = "ca-app-pub-3940256099942544/4411468910";
const adMobRewardedId = "ca-app-pub-3940256099942544/5224354917";
const adMobRewardedIdIos = "ca-app-pub-3940256099942544/1712485313";

// Facebook
const fbBannerId = "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047";
const fbBannerIdIos = "";
const fbInterstitialId = "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617";
const fbInterstitialIdIos = "";
const fbRewardedId = "VID_HD_9_16_39S_APP_INSTALL#YOUR_PLACEMENT_ID";
const fbRewardedIdIos = "";

/// Login Type
const LoginTypeApp = 'app';
const LoginTypeGoogle = 'google';
const LoginTypeOTP = 'otp';
const LoginTypeApple = 'apple';

const IS_LOGGED_IN = 'IS_LOGGED_IN';
const USER_ID = 'USER_ID';
const USER_NAME = 'USER_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_PASSWORD = 'USER_PASSWORD';
const USER_CONTACT_NO = 'USER_CONTACT_NO';
const USER_PROFILE = 'USER_PROFILE';
const LOGIN_TYPE = 'LOGIN_TYPE';
const IS_ADMIN = 'IS_ADMIN';

const IS_FIRST_TIME = 'IS_FIRST_TIME';
const FAVOURITE_LIST = 'FAVOURITE_LIST';
const IS_REMEMBERED = 'IS_REMEMBERED';

const CONTACT_US = "CONTACT_US";
const HELP_AND_SUPPORT = "HELP_AND_SUPPORT";
const PRIVACY_POLICY = "PRIVACY_POLICY";
const PURCHASE = "PURCHASE";
const RATE_US = "RATE_US";
const TERM_AND_CONDITIONS = "TERM_AND_CONDITIONS";
const IS_ADS_ENABLE = "IS_ADS_ENABLE";
const IS_NOTIFICATION_ON = "IS_NOTIFICATION_ON";
const ADS_TYPE = "ADS_TYPE";
const BANNER_ID = 'BANNER_ID';
const BANNER_ID_IOS = 'BANNER_ID_IOS';
const INTERSTITIAL_ID = 'INTERSTITIAL_ID';
const INTERSTITIAL_ID_IOS = 'INTERSTITIAL_ID';
const REWARDED_ID = 'REWARDED_ID';
const REWARDED_ID_IOS = 'REWARDED_ID_IOS';
const NEAR_BY_PLACE_DISTANCE = 'NEAR_BY_PLACE_DISTANCE';
