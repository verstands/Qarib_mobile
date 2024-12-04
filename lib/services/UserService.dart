import 'dart:convert';
import 'package:emol/constant.dart';
import 'package:emol/models/OtpModel.dart';
import 'package:emol/models/UserModel.dart';
import 'package:emol/models/api_response.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> VerifyCompteService(String email, String noms, String password, String telephone, String ville) async {
  ApiResponse apiResponse = ApiResponse();
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
        'latitude': 1,
        'longitude': 1,
        'id_role' : 'cm41epeh0000212o4tdtyxacu',
        'statut': "1"
      },
    );
    print('ffffffffffffffffffffffff${email}');
    switch (response.statusCode) {
      case 202:
        apiResponse.data =
            UserModel.fromJson(jsonDecode(response.body));
        break;
      case 409:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.erreur = errors[errors.keys.elementAt(0)][0];
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
