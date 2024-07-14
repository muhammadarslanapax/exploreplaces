import 'package:flutter/material.dart';

import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import '../main.dart';
import '../models/LanguageDataModel.dart';
import '../utils/AppColor.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';

class LanguageDialog extends StatefulWidget {
  @override
  LanguageDialogState createState() => LanguageDialogState();
}

class LanguageDialogState extends State<LanguageDialog> {
  String selectedLanguageCode = DEFAULT_LANGUAGE;
  LanguageDataModel? selectedLanguage;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    selectedLanguageCode = getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override

  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.cardColor,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: context.height() * 0.7,
        width: context.width() * 0.80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(child: Text(language.selectLanguage, style: boldTextStyle(size: 20)).paddingAll(16)),
            Divider(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: localeLanguageList.length,
                itemBuilder: (context, index) {
                  LanguageDataModel item = localeLanguageList[index];
                  return Row(
                    children: [
                      Image.asset(item.flag.validate(), width: 34),
                      16.width,
                      Text('${item.name.validate()}', style: boldTextStyle(), maxLines: 2),
                      Spacer(),
                      Radio<String>(
                        value: item.languageCode!,
                        groupValue: selectedLanguageCode,
                        activeColor: primaryColor,
                        onChanged: (String? value) {
                          selectedLanguage = item;
                          selectedLanguageCode = value!;
                          setState(() {});
                        },
                      ),
                    ],
                  ).paddingOnly(left: 16, right: 8);
                },
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      finish(context);
                    },
                    child: Text(language.cancel, style: secondaryTextStyle(weight: FontWeight.bold))),
                4.width,
                TextButton(
                    onPressed: () {
                      setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);
                      selectedLanguageDataModel = selectedLanguage;
                      appStore.setLanguage(selectedLanguageCode, context: context);
                      setState(() {});
                      finish(context);
                    },
                    child: Text(language.ok, style: boldTextStyle(color: primaryColor))),
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
