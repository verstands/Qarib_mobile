import 'dart:convert';
import 'package:emol/constant.dart';
import 'package:emol/models/CategorieModel.dart';
import 'package:emol/models/CountServiceUserModel.dart';
import 'package:emol/models/ServiceByUserModel.dart';
import 'package:emol/models/Servicemodel.dart';
import 'package:emol/models/api_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

Future<ApiResponse> getCategorieService() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('$getAllCategorie'),
      headers: {
        'Accept': 'application/json',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => CategorieModel.fromJson(e))
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