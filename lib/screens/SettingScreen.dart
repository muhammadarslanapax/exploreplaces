import '../screens/AboutUsScreen.dart';
import '../services/AuthServices.dart';
import '../utils/AppConstant.dart';
import '../utils/AppImages.dart';
import '../utils/Extensions/AppButton.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../components/LanguageDialog.dart';
import '../components/ThemeDialog.dart';
import '../main.dart';
import '../utils/AppColor.dart';
import '../utils/Common.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/LiveStream.dart';
import '../utils/Extensions/SettingItemWidget.dart';
import '../utils/Extensions/text_styles.dart';
import 'ChangePasswordScreen.dart';
import 'EditProfileScreen.dart';
import 'LogInScreen.dart';
import 'PlacesRequestScreen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    LiveStream().on('UpdateLoginScreen', (p0) {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                16.height,
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: boxDecorationDefaultWidget(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: appStore.profileImg.isNotEmpty
                          ? cachedImage(appStore.profileImg, height: 80, width: 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(40)
                          : Image.asset('assets/profile.png', height: 80, width: 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(40),
                    ),
                    8.height,
                    Text(getStringAsync(USER_NAME), style: boldTextStyle(size: 20)),
                    4.height,
                    Text(getStringAsync(USER_EMAIL), style: secondaryTextStyle(size: 16)),
                    16.height.visible(isLoggedInWithApp()),
                    AppButtonWidget(
                      color: primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(language.editProfile, style: boldTextStyle(color: whiteColor)),
                          4.width,
                          Icon(Icons.navigate_next, color: whiteColor),
                        ],
                      ),
                      onTap: () {
                        EditProfileScreen().launch(context);
                      },
                    ).visible(isLoggedInWithApp()),
                    24.height,
                  ],
                ).visible(appStore.isLoggedIn),
                Container(
                  height: 35,
                  width: context.width(),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldSecondaryDark : primaryColor.withOpacity(0.2)),
                  child: Text(language.generalSetting, style: boldTextStyle(), textAlign: TextAlign.start),
                ),
                SettingItemWidget(
                  leading: ImageIcon(AssetImage(ic_theme)),
                  title: language.appTheme,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ThemeDialog(onUpdate: () {
                            setStatusBarColorWidget(Colors.transparent);
                            setState(() {});
                          });
                        });
                  },
                ),
                SettingItemWidget(
                  leading: ImageIcon(AssetImage(ic_language)),
                  title: language.appLanguage,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return LanguageDialog();
                        });
                  },
                ),
                SettingItemWidget(
                  leading: ImageIcon(AssetImage(ic_lock)),
                  title: language.changePassword,
                  onTap: () {
                    ChangePasswordScreen().launch(context);
                  },
                ).visible(appStore.isLoggedIn && isLoggedInWithApp()),
                Container(
                  height: 35,
                  width: context.width(),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(color: appStore.isDarkMode ? scaffoldSecondaryDark : primaryColor.withOpacity(0.2)),
                  child: Text(language.others, style: boldTextStyle(), textAlign: TextAlign.start),
                ),
                SettingItemWidget(
                  leading: ImageIcon(AssetImage(ic_places_request)),
                  title: language.placesRequest,
                  onTap: () {
                    PlacesRequestScreen().launch(context);
                  },
                ).visible(appStore.isLoggedIn),
                SettingItemWidget(
                  leading: ImageIcon(AssetImage(ic_rate_us)),
                  title: language.rateUs,
                  onTap: () {
                    mLaunchUrl(getStringAsync(RATE_US));
                  },
                ),
                SettingItemWidget(
                  leading: ImageIcon(AssetImage(ic_privacy)),
                  title: language.privacyPolicy,
                  onTap: () {
                    mLaunchUrl(getStringAsync(PRIVACY_POLICY));
                  },
                ),
                SettingItemWidget(
                  leading: ImageIcon(AssetImage(ic_terms_condition)),
                  title: language.termsAndConditions,
                  onTap: () {
                    mLaunchUrl(getStringAsync(TERM_AND_CONDITIONS));
                  },
                ),
                SettingItemWidget(
                  leading: ImageIcon(AssetImage(ic_help_support)),
                  title: language.helpAndSupport,
                  onTap: () {
                    mLaunchUrl(getStringAsync(HELP_AND_SUPPORT));
                  },
                ),
                SettingItemWidget(
                  leading: ImageIcon(AssetImage(ic_about_us)),
                  title: language.aboutUs,
                  onTap: () {
                    AboutUsScreen().launch(context);
                  },
                ),
                SettingItemWidget(
                  leading: ImageIcon(AssetImage(ic_delete_account)),
                  title: language.deleteAccount,
                  onTap: () async {
                    commonConfirmationDialog(context,message: language.deleteAccountMsg, onUpdate: () async {
                      await deleteUser(getStringAsync(USER_EMAIL), getStringAsync(USER_PASSWORD));
                      logout(context);
                    },isDeleteDialog: true);
                  },
                ).visible(appStore.isLoggedIn),
                appStore.isLoggedIn
                    ? SettingItemWidget(
                        leading: ImageIcon(AssetImage(ic_logout)),
                        title: language.logout,
                        onTap: () {
                          commonConfirmationDialog(context,message: language.logoutConfirmation, onUpdate: () async {
                            await logout(context);
                          });
                        },
                      )
                    : SettingItemWidget(
                        leading: ImageIcon(AssetImage(ic_login)),
                        title: language.signIn,
                        onTap: () {
                          LoginScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                        },
                      ),
              ],
            ),
          ),
          Observer(builder: (context) => Visibility(visible: appStore.isLoading, child: Positioned.fill(child: loaderWidget()))),
        ],
      ),
    );
  }
}
