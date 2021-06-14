import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_module/data/api/ISessionApi.dart';
import 'package:flutter_login_module/data/exception/LoginCancelledException.dart';
import 'package:flutter_login_module/common/LoginLogger.dart';
import 'package:google_sign_in/google_sign_in.dart';

const String OP_CANCELED = "sign_in_canceled";

const String TAG = "SessionApiImpl";

/**
 * Implementation for 3rd party session api
 */
class SessionApiImpl implements ISessionApi {
  final FirebaseAuth _generalAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();

  SessionApiImpl();

  @override
  Future<FirebaseUser> getUser() async {
    return await this._generalAuth.currentUser();
  }

  @override
  Future<bool> isMailVerified() async {
    var user = await this.getUser();

    return user.isEmailVerified;
  }

  @override
  Future<FirebaseUser> changeName(String value) async {
    var user = await this.getUser();

    final updatedInfo = UserUpdateInfo()
      ..displayName = value
      ..photoUrl = user.photoUrl;

    await user.updateProfile(updatedInfo);

    return user;
  }
  
  @override
  Future<void> sendEmail() async {
    var user = await this.getUser();

    return user.sendEmailVerification();
  }

  @override
  Future<FirebaseUser> signIn(String mail, String pass, SessionTypes type) async {

    try {
      var ret;
      switch (type) {
        case SessionTypes.GOOGLE:
          ret = await this._googleLogin();
          break;
        case SessionTypes.APPLE:
          ret = await this._appleLogin();
          break;
        case SessionTypes.CUSTOM:
          ret = await this._customLogin(mail, pass);
          break;
      }

      return ret;

    } on PlatformException catch (pe) {
      if (pe.code == OP_CANCELED) {
        throw LoginCancelledException();

      } else {
        throw pe;
      }

    } on Exception catch (e) {
      LoginLogger.e(error: e);

      throw e;
    }
  }

  @override
  Future<void> signOut() async {
    if (await this._googleAuth.isSignedIn()) {
      this._googleAuth.signOut();
    }

    return await this._generalAuth.signOut();
  }

  @override
  Future<FirebaseUser> signUp(String mail, String pass, SessionTypes type) async{
    return await this._generalAuth.createUserWithEmailAndPassword(email: mail, password: pass).then((value) => this.getUser());
  }

  Future<FirebaseUser> _customLogin(String mail, String pass)  async {
    return await this._generalAuth.signInWithEmailAndPassword(email: mail, password: pass).then((value) => this.getUser());
  }
  
  Future<FirebaseUser> _googleLogin() async {
    if (await this._googleAuth.isSignedIn()) {
      return await this.getUser();      
    
    } else {
      final googleAccount = await this._googleAuth.signIn();

      if (googleAccount != null) {
        final auth = await googleAccount.authentication;

        final credentials = GoogleAuthProvider.getCredential(idToken: auth.idToken, accessToken: auth.accessToken);

        final googleUser = (await this._generalAuth.signInWithCredential(credentials))?.user;

        return googleUser;

      } else {
        throw PlatformException(code: OP_CANCELED);
      }
    }
  }

  Future<FirebaseUser> _appleLogin() async {
    final AuthorizationResult res = await AppleSignIn.performRequests(
      [AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]
    );
    
    switch (res.status) {
      case AuthorizationStatus.authorized:
        final prov = OAuthProvider(providerId: SessionTypes.APPLE.getDomain());

        final cred = res.credential;

        final AuthCredential creden = prov.getCredential(
            idToken: String.fromCharCodes(cred.identityToken),
            accessToken: String.fromCharCodes(cred.authorizationCode)
        );
        
        final appleUser = (await this._generalAuth.signInWithCredential(creden))?.user;

        final updatedInfo =
          UserUpdateInfo()
            ..displayName= cred.fullName.givenName;

         await appleUser.updateProfile(updatedInfo);

         return appleUser;

      case AuthorizationStatus.error:
        return null;
        
      case AuthorizationStatus.cancelled:
      default:
        throw PlatformException(code: OP_CANCELED);
    }
  }

  @override
  Future<Map<String, bool>> checkAvailableMethods(List<SessionTypes> candidates) async {
    var map = Map<String, bool>();

    if (candidates.contains(SessionTypes.APPLE)) {
      var appleAvailable = await AppleSignIn.isAvailable();
      map[SessionTypes.APPLE.getAsKey()] = appleAvailable;
    }

    if (candidates.contains(SessionTypes.GOOGLE)) {
      var googleAvailable = true;
      map[SessionTypes.GOOGLE.getAsKey()] = googleAvailable;
    }

    return map;
  }

  @override
  Future<bool> passwordReset() async {
    final user = await this.getUser();

    if (user != null) {
      await this._generalAuth.sendPasswordResetEmail(email: user.email);

      return true;

    } else {
      LoginLogger.e(tag: TAG, msg: "passwordReset() required but no user found", error: null);

      return false;
    }
  }

  @override
  Future<bool> retrievePass(String mail) async {
    await this._generalAuth.sendPasswordResetEmail(email: mail);

    return true;
  }
}
