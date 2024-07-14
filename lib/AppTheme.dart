import '../utils/AppColor.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: createMaterialColor(primaryColor),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.roboto().fontFamily,
    iconTheme: IconThemeData(color: Colors.black),
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.grey,
    dividerColor: viewLineColor,
    cardColor: Colors.white,
    tabBarTheme: TabBarTheme(labelColor: Colors.black),
    textTheme:GoogleFonts.robotoTextTheme(TextTheme(bodyMedium: primaryTextStyle())),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: boldTextStyle(color: Colors.black, size: 22),
    ),
    dialogTheme: DialogTheme(shape: dialogShape()),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
    ),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: createMaterialColor(primaryColor),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldColorDark,
    fontFamily: GoogleFonts.roboto().fontFamily,
    iconTheme: IconThemeData(color: Colors.white),
    dialogBackgroundColor: scaffoldSecondaryDark,
    textTheme:GoogleFonts.robotoTextTheme(TextTheme(bodyMedium: primaryTextStyle())),
    unselectedWidgetColor: Colors.white60,
    dividerColor: Colors.white12,
    cardColor: scaffoldSecondaryDark,
    tabBarTheme: TabBarTheme(labelColor: Colors.white),
    appBarTheme: AppBarTheme(
      color: scaffoldColorDark,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: boldTextStyle(color: Colors.white, size: 22),
    ),
    dialogTheme: DialogTheme(shape: dialogShape()),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: scaffoldSecondaryDark),
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
    ),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
