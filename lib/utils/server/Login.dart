import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  final String email;
  final String password;

  Login(this.email,this.password);

  Future<bool> getData(BuildContext context) async {
    bool isSuccessed;
    int id;
    int rule;
    String image;


    Response response = await get(InfixApi.login(email, password));
    if (response.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(response.body) as Map;
      isSuccessed = user['success'];
      id = user['data']['user']['id'];
      rule = user['data']['user']['role_id'];
      image = user['data']['userDetails']['staff_photo'];

      if (isSuccessed) {
        saveBooleanValue('isLogged', isSuccessed);
        saveStringValue('email', email);
        saveStringValue('password', password);
        saveStringValue('id','$id');
        saveStringValue('rule', '$rule');
        saveStringValue('image', '$image');
        saveStringValue('lang', 'en');
        AppFunction.getFunctions(context,rule.toString());
      }

    }
    return isSuccessed;
  }

  Future<bool> saveBooleanValue(String key ,bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(key, value);
  }

  Future<bool> saveStringValue(String key ,String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

}
