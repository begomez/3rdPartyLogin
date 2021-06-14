/**
 * Custom logger class
 */
class LoginLogger {
  static bool debugMsg = true;
  static bool debugError = true;

  static void log(String msg) {
    if (debugMsg) {
      print(msg);
    }
  }

  static void i({String tag, String msg}) {
    if (debugMsg) {
      print("$tag $msg");
    }
  }

  static void d(String msg) {
    if (debugMsg) {
      print(msg);
    }
  }

  static void e({String tag = "", String msg, Exception error}) {
    if (debugError) {
      print("$tag $msg ${error?.toString()}");
    }
  }
}