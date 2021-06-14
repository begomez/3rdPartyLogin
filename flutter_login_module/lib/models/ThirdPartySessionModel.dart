import 'package:flutter/material.dart';
import 'package:flutter_login_module/models/core/ModuleBaseModel.dart';


/**
 * Model used to wrap 3rd party session objects
 */
class ThirdPartySessionModel implements ModuleBaseModel {
  final int id;
  final String mail;
  final String display;
  final String pic;
  final String token;
  final bool mailValidationDone;

  const ThirdPartySessionModel({
    this.id = -1,
    this.mail = "",
    this.display = "",
    this.pic = "",
    this.token = "",
    this.mailValidationDone = false
  }) : super();

  factory ThirdPartySessionModel.requiresMailValidation() => ThirdPartySessionModel();

  factory ThirdPartySessionModel.empty() => ThirdPartySessionModel();

  bool hasMail() => this._hasString(this.mail);

  bool hasDisplay() => this._hasString(this.display);

  bool hasPic() => this._hasString(this.pic);

  bool hasToken() => this._hasString(this.token);

  bool _hasString(String str) => str != null && str.isNotEmpty;

  bool validate() => this.hasToken() && this.hasMail();

  @override
  String toString() {
    return 'ThirdPartySessionModel{mail: $mail, display: $display, pic: $pic}';
  }

  ThirdPartySessionModel copyWith({
    int id,
    String mail,
    String display,
    String pic,
    String token,
    bool mailValidationDone
  }) {
    return ThirdPartySessionModel(
      id: id ?? this.id,
      mail: mail ?? this.mail,
      display: display ?? this.display,
      pic: pic ?? this.pic,
      token: token ?? this.token,
      mailValidationDone: mailValidationDone?? this.mailValidationDone
    );
  }
}