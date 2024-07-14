import '../utils/Extensions/device_extensions.dart';
import '../screens/DashboardScreen.dart';
import '../utils/AppColor.dart';
import '../utils/AppImages.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../main.dart';
import '../services/AuthServices.dart';
import '../utils/AppConstant.dart';
import '../utils/Common.dart';
import '../utils/Extensions/AppButton.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import 'ForgotPasswordScreen.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColorWidget(appStore.isDarkMode ? scaffoldColorDark : primaryColor, statusBarIconBrightness: Brightness.light);
    if (!isLoggedInWithGoogle() && getBoolAsync(IS_REMEMBERED)) {
      emailController.text = getStringAsync(USER_EMAIL);
      passwordController.text = getStringAsync(USER_PASSWORD);
    }
  }

  Future<void> signIn() async {
    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);
      await signInWithEmail(emailController.text, passwordController.text).then((user) {
        appStore.setLoading(false);
        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        log(e);
        toast(e.toString().splitAfter(']').trim());
      });
    }
  }

  appleLogin() async {
    hideKeyboard(context);
    appStore.setLoading(true);
    await appleLogIn().then((value) {
      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColorWidget(appStore.isDarkMode ? scaffoldColorDark : Colors.white, statusBarIconBrightness: Brightness.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkMode ? scaffoldColorDark : primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(language.signIn),
        backgroundColor: appStore.isDarkMode ? scaffoldColorDark : primaryColor,
        titleTextStyle: boldTextStyle(color: Colors.white, size: 20),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom+16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  16.height,
                  Image.asset(login_logo_image, width: 100, height: 100),
                  16.height,
                  Text(language.signInText, style: primaryTextStyle(color: Colors.white, size: 18), textAlign: TextAlign.center),
                  30.height,
                  AppTextField(
                    controller: emailController,
                    textFieldType: TextFieldType.EMAIL,
                    decoration: commonInputDecoration(
                      hintText: language.email,
                      prefixIcon: Icon(Icons.email),
                      bgColor: context.cardColor,
                    ),
                    focus: emailFocus,
                    nextFocus: passFocus,
                  ),
                  16.height,
                  AppTextField(
                    controller: passwordController,
                    textFieldType: TextFieldType.PASSWORD,
                    focus: passFocus,
                    decoration: commonInputDecoration(
                      hintText: language.password,
                      prefixIcon: Icon(Icons.lock),
                      bgColor: context.cardColor,
                    ),
                  ),
                  8.height,
                  Row(
                    children: [
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: Colors.white,
                        ),
                        child: Checkbox(
                          value: getBoolAsync(IS_REMEMBERED, defaultValue: false),
                          activeColor: context.cardColor,
                          checkColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: radius(0)),
                          onChanged: (v) async {
                            await setValue(IS_REMEMBERED, v);
                            setState(() {});
                          },
                        ),
                      ),
                      Text(language.rememberMe, style: primaryTextStyle())
                    ],
                  ),
                  16.height,
                  AppButtonWidget(
                    text: language.signIn,
                    textStyle: boldTextStyle(color: primaryColor),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                    color: context.cardColor,
                    onTap: () {
                      signIn();
                    },
                    width: context.width(),
                  ),
                  8.height,
                  Align(
                    alignment: appStore.selectedLanguage == 'ar' ? Alignment.topLeft : Alignment.topRight,
                    child: Text(language.forgotPasswordQue, style: primaryTextStyle()).onTap(() async {
                      ForgotPasswordScreen().launch(context);
                    }),
                  ),
                  16.height,
                  Row(
                    children: [
                      Divider().expand(),
                      16.width,
                      Text(language.orSignInWith, style: secondaryTextStyle(size: 14, color: Colors.white70)),
                      16.width,
                      Divider().expand(),
                    ],
                  ),
                  16.height,
                  OutlinedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icon/ic_google.png', height: 24, width: 24),
                        16.width,
                        Text(language.signInWithGoogle, style: primaryTextStyle(color: Colors.white)),
                      ],
                    ),
                    onPressed: () async {
                      appStore.setLoading(true);

                      await signInWithGoogle().then((user) {
                        appStore.setLoading(false);
                        DashboardScreen().launch(context, isNewTask: true);
                      }).catchError((e) {
                        appStore.setLoading(false);
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      textStyle: boldTextStyle(color: primaryColor),
                      side: BorderSide(color: context.dividerColor, style: BorderStyle.solid),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(defaultRadius),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                  16.height.visible(isIos),
                  OutlinedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icon/ic_apple.png', height: 24, width: 24),
                        16.width,
                        Text(language.signInWithApple, style: primaryTextStyle(color: Colors.white)),
                      ],
                    ),
                    onPressed: () {
                      appleLogin();
                    },
                    style: OutlinedButton.styleFrom(
                      textStyle: boldTextStyle(color: primaryColor),
                      side: BorderSide(color: context.dividerColor, style: BorderStyle.solid),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(defaultRadius),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ).visible(isIos),
                ],
              ),
            ),
          ),
          Observer(builder: (context) => loaderWidget().visible(appStore.isLoading)),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(language.doNotHaveAnAccount, style: primaryTextStyle(color: Colors.white)),
          6.width,
          Text(language.signUp, style: boldTextStyle(color: Colors.white)).onTap(() {
            RegisterScreen().launch(context);
          }),
        ],
      ).paddingAll(16),
    );
  }
}
