import 'dart:io';

import '../utils/AppConstant.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../services/FileStorageService.dart';
import '../utils/AppColor.dart';
import '../utils/Common.dart';
import '../utils/Extensions/AppButton.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/ModelKeys.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode contactFocus = FocusNode();

  File? image;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    emailController.text = getStringAsync(USER_EMAIL);
    nameController.text = getStringAsync(USER_NAME);
    contactController.text = getStringAsync(USER_CONTACT_NO);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future getImg() async {
    image = File((await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100))!.path);
    setState(() {});
  }

  Widget profileImage() {
    if (image != null) {
      return Image.file(File(image!.path), height: 120, width: 120, fit: BoxFit.cover).cornerRadiusWithClipRRect(85);
    } else {
      if (appStore.profileImg.isNotEmpty) {
        return cachedImage(appStore.profileImg, height: 120, width: 120, fit: BoxFit.cover).cornerRadiusWithClipRRect(85);
      } else {
        return Image.asset('assets/profile.png', height: 120, width: 120, fit: BoxFit.cover)
            .cornerRadiusWithClipRRect(85);
      }
    }
  }

  Future<void> save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);

      Map<String, dynamic> req = {};

      if (nameController.text != getStringAsync(USER_NAME)) {
        req.putIfAbsent(UserKeys.name, () => nameController.text.trim());
      }

      if (contactController.text != getStringAsync(USER_CONTACT_NO)) {
        req.putIfAbsent(UserKeys.contactNo, () => contactController.text.trim());
      }

      req.putIfAbsent(CommonKeys.updatedAt, () => DateTime.now());

      if (image != null) {
        await uploadFile(file: image, prefix: mProfileStoragePath).then((path) async {
          req.putIfAbsent(UserKeys.profileImg, () => path);

          await setValue(USER_PROFILE, path);
          appStore.setProfileImg(path);
        }).catchError((e) {
          toast(e.toString());
        });
      }

      await userService.updateDocument(req, getStringAsync(USER_ID)).then((value) async {
        appStore.setLoading(false);
        setValue(USER_NAME, nameController.text.trim());
        setValue(USER_CONTACT_NO, contactController.text.trim());

        finish(context);
      }).catchError((e) {
        appStore.setLoading(false);
        throw e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(language.editProfile)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(2),
                      decoration: boxDecorationDefaultWidget(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: profileImage()),
                  8.height,
                  Text(language.upload, style: boldTextStyle(color: primaryColor)).onTap(() {
                    getImg();
                  }),
                  30.height,
                  AppTextField(
                    controller: nameController,
                    textFieldType: TextFieldType.NAME,
                    decoration: commonInputDecoration(hintText: language.name, prefixIcon: Icon(Icons.person)),
                    focus: nameFocus,
                    nextFocus: contactFocus,
                  ),
                  16.height,
                  AppTextField(
                    controller: contactController,
                    textFieldType: TextFieldType.PHONE,
                    decoration: commonInputDecoration(hintText: language.contactNo, prefixIcon: Icon(Icons.phone)),
                    focus: contactFocus,
                    nextFocus: emailFocus,
                  ),
                  16.height,
                  AppTextField(
                    controller: emailController,
                    textFieldType: TextFieldType.EMAIL,
                    decoration: commonInputDecoration(hintText: language.email, prefixIcon: Icon(Icons.email)),
                    focus: emailFocus,
                    readOnly: true,
                    onTap: (){
                      toast(language.youCannotChangeIt);
                    },
                  ),
                  30.height,
                  AppButtonWidget(
                    text: language.editProfile,
                    textStyle: boldTextStyle(color: whiteColor),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                    color: primaryColor,
                    onTap: () {
                      save();
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
