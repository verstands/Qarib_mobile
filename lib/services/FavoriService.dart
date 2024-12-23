import 'dart:convert';

import 'package:emol/constant.dart';
import 'package:emol/models/api_response.dart';
import 'package:emol/models/favoriModel.dart';
import 'package:http/http.dart' as http;


Future<ApiResponse> getFavorieByUser(String id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('${getFavori}/${id}'),
      headers: {
        'Accept': 'application/json',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => FavoriModel.fromJson(e))
            .toList();
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