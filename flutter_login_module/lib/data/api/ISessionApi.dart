import 'package:firebase_auth/firebase_auth.dart';

/**
 * Helper method
 */
SessionTypes fromString(String str) {
  if (SessionTypes.APPLE.getAsKey().contains(str)) {
    return SessionTypes.APPLE;
  } else if (SessionTypes.GOOGLE.getAsKey().contains(str)) {
    return SessionTypes.GOOGLE;
  } else if (SessionTypes.FACEBOOK.getAsKey().contains(str)) {
    return SessionTypes.FACEBOOK;
  }
}

/**
 * Enum for 3rd party methods
 */
enum SessionTypes {APPLE, GOOGLE, FACEBOOK, CUSTOM}
extension Names on SessionTypes {
  String getAsKey() => this.toString().toLowerCase().replaceAll("sessiontypes.", "");

  String getDomain() {
    switch (this) {
      case SessionTypes.APPLE:
        return "apple.com";

      case SessionTypes.GOOGLE:
        return "google.com";

      case SessionTypes.FACEBOOK:
        return "facebook.com";

      default:
        return "";
    }
  }
}

/**
 * Abstraction for 3rd party session api
 */
abstract class ISessionApi {
  Future<FirebaseUser> signIn(String mail, String pass, SessionTypes type);
  Future<FirebaseUser> signUp(String mail, String pass, SessionTypes type);
  Future<Map<String, bool>> checkAvailableMethods(List<SessionTypes> candidates);
  Future<void> signOut();
  Future<void> sendEmail();
  Future<FirebaseUser> getUser();
  Future<bool> isMailVerified();
  Future<FirebaseUser> changeName(String value);
  Future<bool> passwordReset();
  Future<bool> retrievePass(String mail);
}