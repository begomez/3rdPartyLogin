import 'package:flutter/material.dart';
import 'package:flutter_login_module/models/core/ModuleBaseModel.dart';


/**
 * Model used to check available signin methods
 */
class CheckSigninModel extends ModuleBaseModel {
  final Map<String, bool> availableMethods;

  const CheckSigninModel(this.availableMethods) : super();

  bool getValueForKeyOrDefault({@required String key, bool defValue = false}) => this.availableMethods[key] ?? defValue;
}