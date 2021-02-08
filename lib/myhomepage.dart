import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './services/api_service.dart';
import './variables.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  bool hideText = true;

  String mobileNumber;
  String pin;

  void autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accesstoken = prefs.getString('accesstoken');
    final String refreshtoken = prefs.getString('refreshtoken');
    final String userid = prefs.getString('userid');
    print('$accesstoken, $refreshtoken, $userid');

    if (accesstoken != null && refreshtoken != null && userid != null) {
      setState(() {
        userId = userid;
        accessToken = accesstoken;
        refreshToken = refreshtoken;
        isLoggedIn = true;
      });
      return;
    }
  }

  void loginUser(Map<String, dynamic> data) async {
    Map<String, dynamic> tokens = await ApiService().getTokens(data);
    print('inside login');
    print(tokens["access_token"]);

    if (tokens["access_token"] != null && tokens["refresh_token"] != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('accesstoken', tokens["access_token"]);
      prefs.setString('refreshtoken', tokens["refresh_token"]);
      prefs.setString('userid', data["user_id"]);
      setState(() {
        accessToken = tokens["access_token"];
        refreshToken = tokens["refresh_token"];
        userId = data["user_id"];
      });
      print('caling second function');
      ApiService().getUserDetails(accessToken, userId);
    } else {
      print('User not exists, please create a account');
    }
  }

  @override
  void initState() {
    super.initState();
    autoLogin();
    // print('$userId, $accessToken, $refreshToken');
    // print(isLoggedIn);
    // print(userId.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: mobileNumberController,
                    decoration: InputDecoration(
                      hintText: 'Enter Mobile Number',
                      labelText: 'Mobile Number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  TextFormField(
                    obscureText: hideText,
                    controller: pinController,
                    maxLength: 4,
                    decoration: InputDecoration(
                        hintText: 'Enter Pin',
                        labelText: 'Pin',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: hideText
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () {
                            setState(() {
                              hideText = !hideText;
                            });
                          },
                        )),
                  ),
                  FlatButton(
                    color: Colors.green,
                    child: Text('Login'),
                    onPressed: () {
                      setState(() {
                        mobileNumber = mobileNumberController.text;
                        pin = pinController.text;
                      });
                      if (mobileNumber.length < 10 && pin.length < 4) {
                        print('invalid');
                      } else {
                        print('valid');
                        print('Mobile Number : $mobileNumber, Pin : $pin');
                        var data = {"user_id": mobileNumber, "pin": pin};
                        loginUser(data);
                        // ApiService().getTokens(data);
                        mobileNumberController.clear();
                        pinController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.file_download_done),
        onPressed: () {
          print('$userId, $accessToken, $refreshToken, $isLoggedIn');
        },
      ),
    );
  }
}
