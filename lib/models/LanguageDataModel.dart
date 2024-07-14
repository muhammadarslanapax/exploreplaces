import 'package:flutter/material.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/string_extensions.dart';
import '../main.dart';

class LanguageDataModel {
  int? id;
  String? name;
  String? languageCode;
  String? fullLanguageCode;
  String? flag;
  String? subTitle;

  LanguageDataModel({
    this.id,
    this.name,
    this.languageCode,
    this.flag,
    this.fullLanguageCode,
    this.subTitle,
  });

  static List<String> languages() {
    List<String> list = [];

    localeLanguageList.forEach((element) {
      list.add(element.languageCode.validate());
    });

    return list;
  }

  static List<Locale> languageLocales() {
    List<Locale> list = [];

    localeLanguageList.forEach((element) {
      list.add(Locale(element.languageCode.validate(), element.fullLanguageCode.validate()));
    });

    return list;
  }
}

LanguageDataModel? getSelectedLanguageModel({String? defaultLanguage}) {
  LanguageDataModel? data;

  localeLanguageList.forEach((element) {
    if (element.languageCode == getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage ?? DEFAULT_LANGUAGE)) {
      data = element;
    }
  });

  return data;
}
