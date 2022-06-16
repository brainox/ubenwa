import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ubenwa/models/newborns.dart';

import '../utils/result.dart';

class DioClient with ChangeNotifier {
  final _baseUrl = 'https://ubenwa-cat-api-stage.herokuapp.com/api/v1';
  String? _token;
  int? _userId;
  var dio = Dio();

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null) {
      return _token!;
    }
    return null;
  }

  int? get userId {
    return _userId;
  }

  // Future<void> _authenticate(String email, String firstName, String String password, String urlSegment) {
  //
  // }

  Future<Result<void>> signup(
      {required String email,
      required String firstName,
      required String lastName,
      required String password,
      required String passwordConfirmation}) async {
    Result<void> result = Result(
      error: false,
    );
    final pathUrl = _baseUrl + "/signup";
    var body = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation
    };
    try {
      final response = await dio.post(pathUrl, data: body);
      final int? statusCode = response.statusCode;
      var response1 = response.data;
      print("response1 ${response1}");
      print("statusCode ${statusCode}");
      if (statusCode != 200 && statusCode != 201) {
        result.error = true;
        result.statusCode = statusCode.toString();
      } else {
        result.error = false;
        result.statusCode = statusCode.toString();
      }
      notifyListeners;
    } catch (error) {
      result.error = false;
    }
    return result;
  }

  Future<Result<void>> login(
      {required String email, required String password}) async {
    Result<void> result = Result(
      error: false,
    );
    final pathUrl = _baseUrl + "/login";
    var body = {
      'email': email,
      'password': password,
    };
    try {
      final response = await dio.post(pathUrl, data: body);
      final int? statusCode = response.statusCode;
      var responseData = response.data;
      if (responseData['error'] != null) {
        // throw HttpException(responseData['error']['message']);
        print("error in ${responseData["error"]}");
      }
      _token = responseData['token'];
      _userId = responseData['user_id'];

      print("response1 ${responseData}");
      print("statusCode ${statusCode}");
      print("Token is ${_token}");
      print("User id is ${_userId}");
      if (statusCode != 200 && statusCode != 201) {
        result.error = true;
        result.statusCode = statusCode.toString();
      } else {
        result.error = false;
        result.statusCode = statusCode.toString();
      }
      notifyListeners;
    } catch (error) {
      result.error = false;
    }
    return result;
  }

  Future<Result<void>> createNewBorn(
      {required String name,
      required String gestation,
      required String gender}) async {
    Result<void> result = Result(
      error: false,
    );
    final pathUrl = _baseUrl + "/newborns";
    var bodyData = {
      "data": {
        "type": "newborns",
        "attributes": {
          "name": name,
          "gestation": gestation,
          "gender": gender,
        }
      }
    };

    var header = {
      HttpHeaders.contentTypeHeader: 'application/vnd.api+json',
      HttpHeaders.authorizationHeader: "Bearer ${token}"
    };

    print("the token is ${token}");
    try {
      final response = await dio.post(pathUrl,
          data: bodyData, options: Options(headers: header));
      final int? statusCode = response.statusCode;
      var responseDatad = response.data;
      if (responseDatad['error'] != null) {
        print("error in ${responseDatad["error"]}");
      }
      print("response from create new borns ${responseDatad}");
      print("statusCode from create new borns ${statusCode}");
      if (statusCode != 200 && statusCode != 201) {
        result.error = true;
        result.statusCode = statusCode.toString();
      } else {
        result.error = false;
        result.statusCode = statusCode.toString();
      }
      notifyListeners;
    } catch (error) {
      result.error = false;
      throw (error);
    }
    return result;
  }

  Future<Newborns?> viewAllNewborns() async {
    Result<void> result = Result(
      error: false,
    );
    final pathUrl = _baseUrl + "/newborns";
    Newborns? newborns;
    var header = {
      HttpHeaders.contentTypeHeader: 'application/vnd.api+json',
      HttpHeaders.authorizationHeader: "Bearer ${token}"
    };
    print("PATHURL: ${pathUrl}");
    print("BEARER TOKEN: Bearer ${token}");
    try {
      Response newbornsResponse =
          await dio.get(pathUrl, options: Options(headers: header));
      print('RESPONSE: ${newbornsResponse}');
      newborns = Newborns.fromJson(newbornsResponse.data);
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
        print('ERROR MESSAGE: ${e.message}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }

    // https://ubenwa-cat-api-stage.herokuapp.com/api/v1/newborns
    return newborns;
  }
}
