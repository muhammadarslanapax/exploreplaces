import '../main.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/AppColor.dart';
import '../utils/AppImages.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/text_styles.dart';
import 'DashboardScreen.dart';
import 'WalkThroughScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColorWidget(appStore.isDarkMode ? scaffoldColorDark : Colors.white, statusBarIconBrightness: Brightness.dark);
    await 5.seconds.delay;
    if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
      WalkThroughScreen().launch(context, isNewTask: true);
    } else {
      DashboardScreen().launch(context, isNewTask: true);
    }
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
          Container(
            padding: EdgeInsets.all(10),
            decoration: boxDecorationRoundedWithShadowWidget(16),
            child: Image.asset(ic_appLogo_transparent, fit: BoxFit.cover, height: 100, width: 100),
          ).center(),
          Align(alignment: Alignment.bottomCenter, child: Text(appName, style: boldTextStyle(size: 24)).paddingOnly(bottom: 30)),
        ],
      ),
    );
  }
}
