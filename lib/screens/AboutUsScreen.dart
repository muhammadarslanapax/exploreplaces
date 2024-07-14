import '../utils/AppColor.dart';
import '../utils/Common.dart';
import '../utils/Extensions/AppButton.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../main.dart';
import '../utils/AppConstant.dart';
import '../utils/AppImages.dart';
import '../utils/Extensions/text_styles.dart';

class AboutUsScreen extends StatefulWidget {
  static String tag = '/AboutUsScreen';

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(language.aboutUs)),
      body: Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: boxDecorationRoundedWithShadowWidget(16),
                child: Image.asset(ic_appLogo_transparent, fit: BoxFit.cover, height: 100, width: 100),
              ),
              16.height,
              Text(appName, style: primaryTextStyle(size: 20)),
              8.height,
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return Text('v${snap.data!.version}', style: secondaryTextStyle());
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: AppButtonWidget(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
              color: primaryColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.contact_support_outlined, color: Colors.white),
                  8.width,
                  Text(language.contactUs, style: boldTextStyle(color: Colors.white)),
                ],
              ),
              onTap: () {
                mLaunchUrl('mailto:${getStringAsync(CONTACT_US)}');
              },
            ),
          ).paddingRight(16),
          10.height,
          Align(
            alignment: Alignment.topRight,
            child: AppButtonWidget(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
              color: primaryColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/icon/ic_purchase.png', height: 24, color: Colors.white),
                  8.width,
                  Text(language.purchase, style: boldTextStyle(color: Colors.white)),
                ],
              ),
              onTap: () {
                mLaunchUrl(getStringAsync(PURCHASE));
              },
            ),
          ).paddingRight(16),
          16.height,
          showBannerAd(),
        ],
      ),
    );
  }
}
