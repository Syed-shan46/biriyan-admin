// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:biriyan/services/get_service_key.dart';
import 'package:http/http.dart' as http;

class SendNotificationService {
  static Future<void> sendNotificationUsingApi({
    required String token,
    required String? title,
    required String? body,
  }) async {
    String serverKey = await GetServerKey().getServerKeyToken();
    print("notification server key => ${serverKey}");
    String url =
        "https://fcm.googleapis.com/v1/projects/biriyani-59ef6/messages:send";

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    //mesaage
    Map<String, dynamic> message = {
      "message": {
        "token": token,
        //"topic": "all",
        "notification": {"body": body, "title": title},
      }
    };

    //hit api
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("Notification Send Successfully!");
    } else {
      print("Notification not send!");
    }
  }
}
