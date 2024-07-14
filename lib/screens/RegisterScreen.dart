import '../screens/DashboardScreen.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../main.dart';
import '../services/AuthServices.dart';
import '../utils/AppColor.dart';
import '../utils/AppImages.dart';
import '../utils/Common.dart';
import '../utils/Extensions/AppButton.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode contactFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);

      await signUpWithEmail(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        contactNo: contactController.text.trim(),
      ).then((value) {
        appStore.setLoading(false);

        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        toast(e.toString());

        appStore.setLoading(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkMode ? scaffoldColorDark : primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(language.signUp),
        backgroundColor: appStore.isDarkMode ? scaffoldColorDark : primaryColor,
        titleTextStyle: boldTextStyle(color: Colors.white, size: 20),
        iconTheme: IconThemeData(color: Colors.white),
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
                  Text(language.signUpText, style: primaryTextStyle(color: Colors.white, size: 18), textAlign: TextAlign.center),
                  30.height,
                  AppTextField(
                    controller: nameController,
                    textFieldType: TextFieldType.NAME,
                    decoration: commonInputDecoration(
                      hintText: language.name,
                      prefixIcon: Icon(Icons.person),
                      bgColor: context.cardColor,
                    ),
                    focus: nameFocus,
                    nextFocus: contactFocus,
                  ),
                  16.height,
                  AppTextField(
                    controller: contactController,
                    textFieldType: TextFieldType.PHONE,
                    decoration: commonInputDecoration(
                      hintText: language.contactNo,
                      prefixIcon: Icon(Icons.phone),
                      bgColor: context.cardColor,
                    ),
                    focus: contactFocus,
                    nextFocus: emailFocus,
                  ),
                  16.height,
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
                  30.height,
                  AppButtonWidget(
                    text: language.signUp,
                    textStyle: boldTextStyle(color: primaryColor),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                    color: context.cardColor,
                    onTap: () {
                      signUp();
                    },
                    width: context.width(),
                  ),
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
          Text(language.alreadyHaveAnAccount, style: primaryTextStyle(color: Colors.white)),
          6.width,
          Text(language.signIn, style: boldTextStyle(color: Colors.white)).onTap(() {
            finish(context);
          }),
        ],
      ).paddingAll(16),
    );
  }
}
