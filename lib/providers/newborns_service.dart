import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class NewbornsService extends ChangeNotifier {
  var dio = Dio();

  Future<void> createNewBorn(
      String name, String gestation, String gender) async {
    const pathUrl =
        "https://ubenwa-cat-api-stage.herokuapp.com/api/v1/newborns";
    // var body = {
    //   'email': email,
    //   'password': password,
    // };
    var body = {
      "data": {
        "type": "newborns",
        "attributes": {
          "name": name,
          "gestation": gestation,
          "gender": gender,
        }
      }
    };
    var headers = {
      "token":
          "eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2NTUxMzA3ODIsImV4cCI6MTcxODAyOTk4Miwic3ViIjozfQ.bQnBP8Z285iTwgWAcayEU7SVr6SHP9jurde9SeamiOQ"
    };

    try {
      final response = await dio.post(pathUrl,
          data: body, options: Options(headers: headers));
      final int? statusCode = response.statusCode;
      var responseData = response.data;
      if (responseData['error'] != null) {
        // throw HttpException(responseData['error']['message']);
        print("error in ${responseData["error"]}");
      }
      // _token = responseData['token'];
      // _userId = responseData['user_id'];

      print("response1 ${responseData}");
      print("statusCode ${statusCode}");
      // print("Token is ${_token}");
      // print("User id is ${_userId}");
      notifyListeners;
    } catch (error) {
      throw (error);
    }
  }
}
