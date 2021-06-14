import 'package:flutter/services.dart';
import 'package:flutter_login_module/business/repo/ISessionRepo.dart';
import 'package:flutter_login_module/data/exception/LoginCancelledException.dart';
import 'package:flutter_login_module/data/exception/LoginDataException.dart';
import 'package:flutter_login_module/models/CheckSigninModel.dart';
import 'package:flutter_login_module/models/ThirdPartySessionModel.dart';
import 'package:flutter_login_module/data/api/ISessionApi.dart';
import 'package:flutter_login_module/network/api/impl/SessionApiImpl.dart';
import 'package:flutter_login_module/common/LoginLogger.dart';
import '../../models/ThirdPartySessionModel.dart';


const String TAG = "SessionRepoImpl";


/**
 * Implementation for 3rd party session repository
 */
class SessionRepoImpl implements ISessionRepo {
  final ISessionApi api = SessionApiImpl();

  SessionRepoImpl();

  @override
  Future<CheckSigninModel> checkSignersAvailable(List<String> signers) async {
    var input = signers.map((e) => fromString(e)).toList();

    return CheckSigninModel(await this.api.checkAvailableMethods(input));
  }

  @override
  Future<ThirdPartySessionModel> signUp(String mail, String pass, String name) async {
    try {
      var data = await this.api.signUp(mail, pass, SessionTypes.CUSTOM);

      // DATA
      if (data != null) {
        var tokenId = await data.getIdToken(refresh: true);

        if (!data.isEmailVerified) {
          await this.api.sendEmail();
        }

        return ThirdPartySessionModel(
          token: tokenId.token ?? "",
          display: data.displayName,
          mail: data.email,
          pic: data.photoUrl,
          mailValidationDone: data.isEmailVerified,
        );

      // NO DATA
      } else {
        return ThirdPartySessionModel.requiresMailValidation();
      }

    } on PlatformException catch(pe) {
      LoginLogger.e(tag: TAG, msg:"${pe.toString()}", error: pe);
      throw pe;

    } on Exception catch (e) {
      LoginLogger.e(tag: TAG, msg:"${e.toString()}", error: e);
      throw LoginDataException();
    }
  }

  @override
  Future<ThirdPartySessionModel> signIn(String mail, String pass, SessionTypes type) async {
    try {
      var data = await this.api.signIn(mail, pass, type);

      // DATA
      if (data != null) {
        var tokenId = await data.getIdToken(refresh: true);
        
        LoginLogger.d("$TAG retrieved user: ${data.toString()} with token: ${tokenId.token}");

        return ThirdPartySessionModel(
          token: tokenId.token,
          display: data.displayName ?? "",
          mail: data.email,
          pic: data.photoUrl ?? "",
          mailValidationDone: data.isEmailVerified
        );
        
      // NO DATA
      } else {
        return null;
      }

    } on LoginCancelledException catch (lce) {
      LoginLogger.e(tag: TAG, msg: "${lce.toString()}", error: lce);
      return ThirdPartySessionModel.empty();

    } on PlatformException catch (pe) {
      LoginLogger.e(tag: TAG, msg: "${pe.toString()}", error: pe);
      throw pe;

    } on Exception catch (e) {
      LoginLogger.e(tag: TAG, msg: "${e.toString()}", error: e);
      throw LoginDataException();
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await this.api.signOut();

      return true;

    } on Exception catch (e) {
      LoginLogger.e(tag: TAG, msg: "${e.toString()}", error: e);
      throw LoginDataException();
    }
  }
}
