import 'dart:convert';

import 'package:http/http.dart' as http;

class Remote {
  Future<dynamic> getRequestHttps(
      {required String url,
      required String path,
      Map<String, dynamic>? parameter}) async {
    var uri = Uri.https(url, path, parameter);

    http.Response response = await http.get(uri);

    try {
      if (response.statusCode == 200) {
        var decodeData = jsonDecode(response.body);

        return decodeData;
      }

      return "No response";
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> getRequestHttp(String url, String path) async {
    var uri = Uri.http(url, path, {'q': '{http}'});

    http.Response response = await http.get(uri);

    try {
      if (response.statusCode == 200) {
        var decodeData = jsonDecode(response.body);

        return decodeData;
      }

      return "";
    } catch (e) {
      return "";
    }
  }
}
