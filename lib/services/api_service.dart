import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  String baseUrl =
      'https://xcqjhbmb01.execute-api.ap-south-1.amazonaws.com/dev';

  Future<Map<String, dynamic>> getTokens(
      Map<String, dynamic> loginDetails) async {
    var response =
        await http.post('$baseUrl/user-auth', body: json.encode(loginDetails));
    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      return decodedData;
      // print(decodedData);
    } else if (response.statusCode == 400) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getUserDetails(
      String accesstoken, userid) async {
    Uri uri = Uri.parse('$baseUrl/get-user-details');
    final newUri = uri.replace(queryParameters: {"user_id": "$userid"});
    var response = await http.get(newUri, headers: {
      "authorizationToken": "$accesstoken",
    });
    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      return decodedData;
    } else if (response.statusCode == 403) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> generateAccessToken(String refreshToken) async {
    var body = {"access_token": refreshToken};
    var response =
        await http.post('$baseUrl/refresh-token', body: json.encode(body));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
