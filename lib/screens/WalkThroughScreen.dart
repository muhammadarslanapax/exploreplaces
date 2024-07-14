import '../screens/DashboardScreen.dart';
import '../utils/AppConstant.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/AppColor.dart';
import '../utils/DataProvider.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/text_styles.dart';

class WalkThroughScreen extends StatefulWidget {
  static String tag = '/WalkThroughScreen';

  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController pageController = PageController();

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColorWidget(Colors.transparent, statusBarIconBrightness: Brightness.light);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: walkThoughtList.map((e) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(e.image!, height: context.height(), width: context.width(), fit: BoxFit.cover),
                  Container(
                    height: context.height(),
                    width: context.width(),
                    decoration: boxDecorationWithRoundedCornersWidget(
                      borderRadius: radius(0),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
            onPageChanged: (i) {
              currentPage = i;
              setState(() {});
            },
          ),
          Positioned(
            top: context.statusBarHeight + 4,
            right: 0,
            child: TextButton(
              onPressed: () {
                setValue(IS_FIRST_TIME, false);
                DashboardScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide, isNewTask: true);
              },
              child: Text(language.skip, style: boldTextStyle(color: whiteColor)),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(walkThoughtList[currentPage].title!.toUpperCase(), style: boldTextStyle(color: Colors.white, size: 18)),
                16.height,
                Text(walkThoughtList[currentPage].subTitle!, style: primaryTextStyle(color: Colors.white)),
                24.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    dotIndicator(walkThoughtList.length, currentPage),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(currentPage != 2 ? language.next : language.finish, style: boldTextStyle(color: Colors.white)),
                      decoration: boxDecorationRoundedWithShadowWidget(
                        defaultRadius.toInt(),
                        backgroundColor: primaryColor,
                      ),
                      padding: EdgeInsets.all(12),
                    ).onTap(() async {
                      if (currentPage == 2) {
                        setValue(IS_FIRST_TIME, false);
                        DashboardScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide, isNewTask: true);
                      } else {
                        pageController.animateToPage(currentPage + 1, duration: Duration(milliseconds: 300), curve: Curves.linear);
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
