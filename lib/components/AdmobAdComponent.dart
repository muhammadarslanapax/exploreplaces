import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/device_extensions.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/shared_pref.dart';

InterstitialAd? interstitialAd;
RewardedAd? rewardedAd;

String getAdmobBannerId() {
  if (isAndroid) {
    return (getStringAsync(BANNER_ID).isNotEmpty && kReleaseMode) ? getStringAsync(BANNER_ID) : adMobBannerId;
  } else {
    return (getStringAsync(BANNER_ID_IOS).isNotEmpty && kReleaseMode) ? getStringAsync(BANNER_ID_IOS) : adMobBannerIdIos;
  }
}

String getAdmobInterstitialId() {
  if (isAndroid) {
    return (getStringAsync(INTERSTITIAL_ID).isNotEmpty && kReleaseMode) ? getStringAsync(INTERSTITIAL_ID) : adMobInterstitialId;
  } else {
    return (getStringAsync(INTERSTITIAL_ID_IOS).isNotEmpty && kReleaseMode) ? getStringAsync(INTERSTITIAL_ID_IOS) : adMobInterstitialIdIos;
  }
}

String getAdmobRewardedId() {
  if (isAndroid) {
    return (getStringAsync(REWARDED_ID).isNotEmpty && kReleaseMode) ? getStringAsync(REWARDED_ID) : adMobRewardedId;
  } else {
    return (getStringAsync(REWARDED_ID_IOS).isNotEmpty && kReleaseMode) ? getStringAsync(REWARDED_ID_IOS) : adMobRewardedIdIos;
  }
}

showAdmobInterstitialAd() async {
  if (interstitialAd == null) {
    log('Warning: attempt to show interstitial before loaded.');
    return;
  }
  interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) => log('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      log('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      log('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      loadAdmobInterstitialAd();
    },
  );
  interstitialAd!.show();
}

void loadAdmobInterstitialAd() {
  InterstitialAd.load(
      adUnitId: getAdmobInterstitialId(),
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          log('$ad loaded');
          interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('InterstitialAd failed to load: $error.');
          interstitialAd = null;
        },
      ));
}

Widget showAdmobBannerAd() {
  return Container(
    height: 60,
    child: AdWidget(
      ad: BannerAd(
        adUnitId: getAdmobBannerId(),
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(),
      )..load(),
    ),
  );
}

void loadAdmobRewardedAd() {
  RewardedAd.load(
      adUnitId: getAdmobRewardedId(),
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          log('$ad loaded.');
          rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('RewardedAd failed to load');
          rewardedAd = null;
          loadAdmobRewardedAd();
        },
      ));
}

void showAdmobRewardedAd({Function()? onAdCompleted}) {
  if (rewardedAd == null) {
    log('Warning: attempt to show rewarded before loaded.');
    return;
  }
  rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (RewardedAd ad) => log('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (RewardedAd ad) {
      log('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
      onAdCompleted?.call();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      log('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      loadAdmobRewardedAd();
    },
  );

  rewardedAd!.setImmersiveMode(true);
  rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
    log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
  });
  rewardedAd = null;
}
