import '../utils/Extensions/Widget_extensions.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/AppConstant.dart';
import '../utils/Extensions/device_extensions.dart';
import '../utils/Extensions/shared_pref.dart';

bool isInterstitialAdLoaded = false;
bool isRewardedAdLoaded = false;

String getFacebookBannerId() {
  if (isAndroid) {
    return (getStringAsync(BANNER_ID).isNotEmpty && kReleaseMode) ? 'IMG_16_9_APP_INSTALL#${getStringAsync(BANNER_ID)}' : fbBannerId;
  } else {
    return (getStringAsync(BANNER_ID_IOS).isNotEmpty && kReleaseMode) ? getStringAsync(BANNER_ID_IOS) : fbBannerIdIos;
  }
}

String getFacebookInterstitialId() {
  if (isAndroid) {
    return (getStringAsync(INTERSTITIAL_ID).isNotEmpty && kReleaseMode) ? 'IMG_16_9_APP_INSTALL#${getStringAsync(INTERSTITIAL_ID)}' : fbInterstitialId;
  } else {
    return (getStringAsync(INTERSTITIAL_ID_IOS).isNotEmpty && kReleaseMode) ? getStringAsync(INTERSTITIAL_ID_IOS) : fbInterstitialIdIos;
  }
}

String getFacebookRewardedId() {
  if (isAndroid) {
    return (getStringAsync(REWARDED_ID).isNotEmpty && kReleaseMode) ? 'VID_HD_9_16_39S_APP_INSTALL#${getStringAsync(REWARDED_ID)}' : fbRewardedId;
  } else {
    return (getStringAsync(REWARDED_ID_IOS).isNotEmpty && kReleaseMode) ? getStringAsync(REWARDED_ID_IOS) : fbRewardedIdIos;
  }
}

// Load InterstitialAd
void loadFacebookInterstitialAd() {
  FacebookInterstitialAd.loadInterstitialAd(
    placementId: getFacebookInterstitialId(),
    listener: (result, value) {
      log(">> FAN > Interstitial Ad: $result --> $value");
      if (result == InterstitialAdResult.LOADED) isInterstitialAdLoaded = true;

      if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {
        isInterstitialAdLoaded = false;
        loadFacebookInterstitialAd();
      }
    },
  );
}

// Show InterstitialAd
void showFacebookInterstitialAd() {
  if (isInterstitialAdLoaded == true)
    FacebookInterstitialAd.showInterstitialAd();
  else
    log("Interstitial Ad not yet loaded!");
}

/// Show Facebook BannerAd
Widget showFacebookBannerAd() {
  return FacebookBannerAd(
    placementId: getFacebookBannerId(),
    bannerSize: BannerSize.STANDARD,
    listener: (result, value) {
      log("Banner Ad: $result -->  $value");
    },
  );
}

/// Load Facebook Rewarded Ads
void loadFacebookRewardedAd({Function()? onAdCompleted}) {
  log('Facebook Rewarded call');
  FacebookRewardedVideoAd.loadRewardedVideoAd(
    placementId: getFacebookRewardedId(),
    listener: (result, value) {
      log('result:$result');
      if (result == RewardedVideoAdResult.LOADED) {
        log("RewardedAd loaded");
        isRewardedAdLoaded = true;
      }
      if (result == RewardedVideoAdResult.VIDEO_COMPLETE) {
        log("RewardedAd Completed");
        onAdCompleted!.call();
      }
      if (result == RewardedVideoAdResult.VIDEO_CLOSED && (value == true || value["invalidated"] == true)) {
        log("RewardedAd Closed");
        isRewardedAdLoaded = false;
        loadFacebookRewardedAd(onAdCompleted: onAdCompleted);
      }
      if (result == RewardedVideoAdResult.ERROR) {
        log("RewardedAd error:$value");
      }
    },
  );
}

/// show Facebook Rewarded Ads
void showFacebookRewardedAd() {
  if (isRewardedAdLoaded == true)
    FacebookRewardedVideoAd.showRewardedVideoAd();
  else
    log("Rewarded Ad not yet loaded!");
}
