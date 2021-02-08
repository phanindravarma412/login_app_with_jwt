import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  String baseUrl =
      'https://xcqjhbmb01.execute-api.ap-south-1.amazonaws.com/dev';

  Future<Map<String, dynamic>> getTokens(
      Map<String, dynamic> loginDetails) async {
    var response =
        await http.post('$baseUrl/user-auth', body: json.encode(loginDetails));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      print('type : ${decodedData.runtimeType}');
      print(decodedData);
      return decodedData;
      // print(decodedData);
    } else if (response.statusCode == 400) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print('error');
      return null;
    }
  }

  getUserDetails(String accesstoken, userid) async {
    print('inside second function');
    print('$accesstoken, $userid');
    Uri uri = Uri.parse('$baseUrl/get-user-details');
    final newUri = uri.replace(queryParameters: {"user_id": "$userid"});
    var response = await http.get(newUri, headers: {
      "authorizationToken": "$accesstoken",
    });
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      print(json.decode(response.body).runtimeType);
    } else if (response.statusCode == 403) {
      print('expired');
    }
  }
}
