import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../main.dart';
import '../services/AuthServices.dart';
import '../utils/AppColor.dart';
import '../utils/AppConstant.dart';
import '../utils/Common.dart';
import '../utils/Extensions/AppButton.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';

class  ChangePasswordScreen extends StatefulWidget {

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}
class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController passController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  FocusNode passFocus = FocusNode();
  FocusNode newPassFocus = FocusNode();
  FocusNode confirmPassFocus = FocusNode();

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

  Future<void> changePass() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      if(passController.text.trim() != getStringAsync(USER_PASSWORD)) return toast('Old Password not match');
      appStore.setLoading(true);
      await changePassword(newPassController.text.trim()).then((value) async {
        appStore.setLoading(false);
        toast(language.passwordChanged);
        finish(context);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(language.changePassword)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: passController,
                    textFieldType: TextFieldType.PASSWORD,
                    focus: passFocus,
                    nextFocus: newPassFocus,
                    decoration: commonInputDecoration(hintText: language.oldPassword, prefixIcon: Icon(Icons.lock)),
                    onFieldSubmitted: (s) {
                      //
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: newPassController,
                    textFieldType: TextFieldType.PASSWORD,
                    focus: newPassFocus,
                    nextFocus: confirmPassFocus,
                    decoration: commonInputDecoration(hintText: language.newPassword, prefixIcon: Icon(Icons.lock)),
                  ),
                  16.height,
                  AppTextField(
                    controller: confirmPassController,
                    textFieldType: TextFieldType.PASSWORD,
                    focus: confirmPassFocus,
                    decoration: commonInputDecoration(hintText: language.confirmPassword, prefixIcon: Icon(Icons.lock)),
                    validator: (value){
                      if (value!.trim().isEmpty) {
                        return errorThisFieldRequired;
                      }else if(value!= newPassController.text){
                        return language.passwordNotMatch;
                      }
                      return null;
                    },
                  ),
                  30.height,
                  AppButtonWidget(
                    text: language.changePassword,
                    textStyle: boldTextStyle(color: whiteColor),
                    color: primaryColor,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                    onTap: () {
                      changePass();
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
    );
  }
}