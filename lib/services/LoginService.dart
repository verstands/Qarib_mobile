import 'dart:convert';
import 'package:emol/constant.dart';
import 'package:emol/models/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse<Map<String, dynamic>>> SignInService(
    String email, String password) async {
  ApiResponse<Map<String, dynamic>> apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(postSignIn),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    switch (response.statusCode) {
      case 201:
        final responseData = jsonDecode(response.body);
        apiResponse.data = {
          'token': responseData['access_token'],
          'agent_id': responseData['agent']['id'],
          'agent_noms': responseData['agent']['nom'],
          'agent_telephone': responseData['agent']['telephone'],
          'agent_email': responseData['agent']['email'],
        };
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
    apiResponse.erreur =
        "Erreur du serveur : impossible de contacter le serveur.";
  }
  return apiResponse;
}
