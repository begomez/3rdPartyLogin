import 'package:flutter/material.dart';
import 'package:flutter_login_module/data/api/ISessionApi.dart';
import 'package:flutter_login_module/presentation/resources/LoginColors.dart';
import 'package:flutter_login_module/presentation/resources/LoginTexts.dart';

import 'core/ModuleBaseModel.dart';

/**
 * Model used to store configuration supplied by external client
 */
class ExternalConfigModel extends ModuleBaseModel {
  final String fbId;
  final String googleText;
  final String appleText;
  final String fbText;
  final Color loadingColor;

  const ExternalConfigModel({
    this.fbId = "",
    this.googleText = LoginTexts.GOOGLE,
    this.appleText = LoginTexts.APPLE,
    this.fbText = LoginTexts.FACEBOOK,
    this.loadingColor = LoginColors.darkGreyColor
  }) : super();

  factory ExternalConfigModel.empty() => const ExternalConfigModel();

  bool validate() => this.fbId.isNotEmpty && this.googleText.isNotEmpty && this.appleText.isNotEmpty && this.fbText.isNotEmpty;
}