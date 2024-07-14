import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/AppConstant.dart';
import '../utils/Extensions/Widget_extensions.dart';

sendPushMessageToWeb(String token,String title,String subTitle) async {
  try {
    await http
        .post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'key=$serverKey'},
          body: json.encode({
            'to': token,
            'message': {
              'token': token,
            },
            "notification": {
              "title": title,
              "body": subTitle,
            },
          }),
        )
        .then((value) => log(value.body));
  } catch (e) {
    log(e);
  }
}
