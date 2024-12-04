import 'dart:convert';
import 'package:emol/constant.dart';
import 'package:emol/models/OtpModel.dart';
import 'package:emol/models/api_response.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> CodeOtpmailService(String email, String nom) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(getCodeOtpMail),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'noms': nom},
    );
    switch (response.statusCode) {
      case 201:
        apiResponse.data =
            otpModel.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['code'];
        apiResponse.erreur = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.erreur = unauthorized;
        break;
      default:
        apiResponse.erreur = somethingwentwrong;
        break;
    }
  } catch (e) {
    apiResponse.erreur = serverError;
  }
  return apiResponse;
}
