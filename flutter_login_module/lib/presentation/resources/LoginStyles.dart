import 'package:flutter/material.dart';
import 'package:flutter_login_module/presentation/resources/LoginColors.dart';


abstract class SessionStyles {

  static TextStyle get errorDescription =>
    TextStyle(
      fontSize: 13,
      color: Colors.red,
      fontWeight: FontWeight.w300,
    );

  static TextStyle get buttonStyle =>
    TextStyle(
      fontSize: 12,
      color: LoginColors.blackColor,
      fontWeight: FontWeight.w500,
    );
}