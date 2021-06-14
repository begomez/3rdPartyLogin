import 'package:flutter_login_module/models/core/ModuleBaseModel.dart';


/**
 * Model used to encapsulate errors
 */
class ThirdPartySessionErrorModel implements ModuleBaseModel {
  final int code;
  final String trace;

  const ThirdPartySessionErrorModel({this.code = 0, this.trace = ""}) : super();
}