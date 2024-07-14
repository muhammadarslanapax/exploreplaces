import '../utils/AppColor.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/AppConstant.dart';
import '../utils/Common.dart';
import '../utils/Extensions/AppButton.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/text_styles.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String tag = '/ForgotPasswordScreen';

  final bool? isNewTask;

  ForgotPasswordScreen({this.isNewTask});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {

  }

  Future<void> forgotPass() async {
    if (formKey.currentState!.validate()) {
      finish(context);
      appStore.setLoading(true);
      if (await userService.isUserExist(emailController.text, LoginTypeApp)) {
        await auth.sendPasswordResetEmail(email: emailController.text).then((value) {
          toast('${language.resetPasswordSentTo}: ${emailController.text}');
          appStore.setLoading(false);
        }).catchError((e) {
          toast(e.toString());
          appStore.setLoading(false);
        });
      } else {
        toast(language.noUserFound);
        appStore.setLoading(false);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(language.forgotPassword)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(language.forgotPasswordText, style: secondaryTextStyle(size: 16)),
              30.height,
              AppTextField(
                controller: emailController,
                textFieldType: TextFieldType.EMAIL,
                decoration: commonInputDecoration(hintText: language.email, prefixIcon: Icon(Icons.email)),
              ),
              30.height,
              AppButtonWidget(
                text: language.submit,
                textStyle: boldTextStyle(color: whiteColor),
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                color: primaryColor,
                onTap: () {
                  forgotPass();
                },
                width: context.width(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
