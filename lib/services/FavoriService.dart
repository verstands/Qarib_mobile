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
    switch (response.statusCode){
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


Future<ApiResponse<Map<String, dynamic>>>  postFavoriService(String iduser, String idservice) async {
  ApiResponse<Map<String, dynamic>> apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(postFavori),
      headers: {
        'Accept': 'application/json',
      },
      body: {'id_user': iduser, 'id_service': idservice},
    );
    switch (response.statusCode){
      case 201:
         apiResponse.data = jsonDecode(response.body);
        break;
      case 400:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.erreur = errors is List
            ? errors.join("\n")
            : "Une erreur inattendue est survenue";
        break;
      case 401:
        apiResponse.erreur =
            "Non autorisé : veuillez vérifier vos informations d'identification.";
        break;
      case 409:
        final conflictError = jsonDecode(response.body)['message'];
        apiResponse.erreur =
            conflictError is String ? conflictError : "Conflit détecté";
        break;
      default:
        apiResponse.erreur =
            "Une erreur s'est produite, veuillez réessayer plus tard.";
        break;
    }
  } catch (e) {
    apiResponse.erreur = serverError;
  }
  return apiResponse;
}


Future<ApiResponse<Map<String, dynamic>>> SaveUserService(String iduser, String idservice) async {
   ApiResponse<Map<String, dynamic>> apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(postsaveUser),
      headers: {'Accept': 'application/json'},
      body: {'id_user': iduser, 'id_service': idservice},
    );
    switch (response.statusCode) {
      case 201:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 409:
         apiResponse.erreur = jsonDecode(response.body)['message'];
        break;
       case 400:
        final errors = jsonDecode(response.body)['code'];
        apiResponse.erreur = errors[errors.keys.elementAt(0)][0];
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
    apiResponse.erreur = "Aucune connexionss";
  }
  return apiResponse;
}