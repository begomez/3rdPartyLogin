import 'package:flutter_login_module/models/CheckSigninModel.dart';
import 'package:flutter_login_module/models/ThirdPartySessionModel.dart';
import 'package:flutter_login_module/data/api/ISessionApi.dart';


/**
 * Abstraction for 3rd party session repository
 */
abstract class ISessionRepo {
  Future<ThirdPartySessionModel> signUp(String mail, String pass, String name);
  Future<CheckSigninModel> checkSignersAvailable(List<String> signers);
  Future<ThirdPartySessionModel> signIn(String mail, String pass, SessionTypes type);
  Future<bool> signOut();
}