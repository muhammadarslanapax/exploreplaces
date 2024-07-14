import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../main.dart';
import '../utils/AppColor.dart';
import '../utils/AppConstant.dart';
import '../utils/Common.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';

class ThemeDialog extends StatefulWidget {
  final Function()? onUpdate;

  ThemeDialog({this.onUpdate});

  @override
  ThemeDialogState createState() => ThemeDialogState();
}

class ThemeDialogState extends State<ThemeDialog> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    currentIndex = getIntAsync(THEME_MODE_INDEX);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String getName(ThemeModes themeModes) {
    switch (themeModes) {
      case ThemeModes.Light:
        return language.light;
      case ThemeModes.Dark:
        return language.dark;
      case ThemeModes.SystemDefault:
        return language.systemDefault;
    }
  }

  Widget getIcons(BuildContext context, ThemeModes themeModes) {
    switch (themeModes) {
      case ThemeModes.Light:
        return Icon(MaterialCommunityIcons.lightbulb_on_outline, color: context.iconColor);
      case ThemeModes.Dark:
        return Icon(MaterialIcons.nights_stay, color: context.iconColor);
      case ThemeModes.SystemDefault:
        return Icon(MaterialCommunityIcons.theme_light_dark, color: context.iconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.cardColor,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: context.width() * 0.80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(language.appTheme, style: boldTextStyle(size: 20)).paddingAll(16),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: ThemeModes.values.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    getIcons(context, ThemeModes.values[index]),
                    10.width,
                    Text(getName(ThemeModes.values[index]), style: primaryTextStyle()),
                    Spacer(),
                    Radio(
                      activeColor: primaryColor,
                      value: index,
                      groupValue: currentIndex,
                      onChanged: (int? value) {
                        currentIndex = value!;
                        setState(() {});
                      },
                    ),
                  ],
                ).paddingOnly(left: 16,right: 8);
              },
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {
                  finish(context);
                }, child: Text(language.cancel, style: secondaryTextStyle(weight: FontWeight.bold))),
                4.width,
                TextButton(onPressed: () {
                  if (currentIndex == appThemeMode.themeModeSystem) {
                    appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
                  } else if (currentIndex == appThemeMode.themeModeLight) {
                    appStore.setDarkMode(false);
                  } else if (currentIndex == appThemeMode.themeModeDark) {
                    appStore.setDarkMode(true);
                  }
                  setValue(THEME_MODE_INDEX, currentIndex);
                  finish(context);
                  widget.onUpdate!.call();
                }, child: Text(language.ok, style: boldTextStyle(color: primaryColor))),
                8.width,
              ],
            ),
            8.height,
          ],
        ),
      ),
    );
  }
}
