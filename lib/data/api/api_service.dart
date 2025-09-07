import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:expensetracker/data/api/toast_message.dart';
import 'package:http/http.dart' as http;

import 'api_method.dart';
import 'api_urls.dart';
import '../local/local_storage.dart';

class ApiService {


  static Future<bool> loginService({required Map<String, String> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(true).post(ApiUrls.dumb, body, code: 200);
      if (mapResponse != null) {
        // UserLoginRes _resmodel = UserLoginRes.fromJson(mapResponse);
        // LocalStorage.saveToken(token: _resmodel.data!.accessToken!);
        LocalStorage.isLoginSuccess(isLoogedIn: true);

        return true;
      }
    } catch (e) {
      debugPrint('err from Login api service ==> $e');
      return false;
    }
    ToastMessage.error('Something went Wrong!');
    return false;
  }




}
