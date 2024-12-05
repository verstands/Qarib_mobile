import 'dart:convert';
import 'dart:ffi';
import 'package:emol/constant.dart';
import 'package:emol/models/OtpModel.dart';
import 'package:emol/models/UserModel.dart';
import 'package:emol/models/api_response.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse<Map<String, dynamic>>> VerifyCompteService(String email, String noms, String password, String telephone, String ville) async {
   ApiResponse<Map<String, dynamic>> apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(posVerifyCompte),
      headers: {'Accept': 'application/json'},
      body: {
        'email': email, 
        'noms': noms,
        'password': password,
        'telephone': telephone,
        'id_ville': ville,
        'latitude': '1',
        'longitude': '1',
        'id_role' : 'cm41epeh0000212o4tdtyxacu',
        'statut': '1'
      },
    );
    print('eeeeeeeeeeeeeee ${response.statusCode}');
    switch (response.statusCode) {
      case 202:
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


Future<ApiResponse<Map<String, dynamic>>> SaveUserService(String email, String noms, String password, String telephone, String ville, String id_role, String status) async {
   ApiResponse<Map<String, dynamic>> apiResponse = ApiResponse();
   print('ville : ${id_role}');
  try {
    double latitude = 1;
    double longitude = 4;
    final response = await http.post(
      Uri.parse(postsaveUser),
      headers: {'Accept': 'application/json'},
      body: {
        'email': email, 
        'noms': noms,
        'password': password,
        'telephone': telephone,
        'id_ville': ville,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'id_role' : id_role,
        'statut': status
      },
    );
    print(response.body);
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
