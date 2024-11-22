import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastUtil {
  static void showToast(String? message) {
    Fluttertoast.showToast(
      msg: "Message à afficher",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
