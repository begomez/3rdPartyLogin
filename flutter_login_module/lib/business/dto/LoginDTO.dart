import 'package:flutter/material.dart';
import 'package:flutter_login_module/business/dto/core/LoginBaseDTO.dart';

/**
 * DTO to perform a 3rd party login
 */
class LoginDTO extends LoginBaseDTO {
  final String token;
  final String device;
  final String refreshToken;

  const LoginDTO({
    @required this.token,
    @required this.device,
    this.refreshToken = ""}) :  assert(token != null), assert(device != null), super();
}