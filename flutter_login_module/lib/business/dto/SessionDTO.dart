import 'package:flutter/material.dart';
import 'package:flutter_login_module/business/dto/core/LoginBaseDTO.dart';

/**
 * DTO to request session creation
 */
class SessionDTO extends LoginBaseDTO {
  final String mail;
  final String pass;

  const SessionDTO({
    @required this.mail, @required this.pass})
      : assert(mail != null), assert(pass != null), super();
}