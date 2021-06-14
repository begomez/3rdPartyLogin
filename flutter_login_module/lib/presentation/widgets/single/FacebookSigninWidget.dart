import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_module/common/LoginErrorCodes.dart';
import 'package:flutter_login_module/common/LoginLogger.dart';
import 'package:flutter_login_module/models/ThirdPartySessionModel.dart';
import 'package:flutter_login_module/presentation/factories/LoginIconButtonFactory.dart';
import 'package:flutter_login_module/presentation/factories/LoginWidgetFactory.dart';
import 'package:flutter_login_module/presentation/resources/LoginColors.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


const TAG = "FacebookSigninWidget";


/**
 * Widget that performs Facebook sign-in
 */
class FacebookSigninWidget extends StatefulWidget {
  final Function(ThirdPartySessionModel) onSessionSuccess;
  final Function(int) onSessionError;
  final Function() onReset;
  final Function(String) onDisplay;
  final bool available;
  final String btnText;
  final String fbId;

  const FacebookSigninWidget(
      {@required this.onSessionSuccess,
      @required this.onSessionError,
      @required this.onReset,
      this.onDisplay,
      this.available = true,
      @required this.btnText,
      @required this.fbId,
      Key key})
      : assert(onSessionSuccess != null),
        assert(onSessionError != null),
        assert(onReset != null),
        assert(btnText != null),
        assert(fbId != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _FacebookSigninWidgetState(this.fbId);
}

class _FacebookSigninWidgetState extends State<FacebookSigninWidget> {
  static String FB_ID = "";
  static String REDIRECT_URL = "";
  static String SELECTED_URL = "";

  _FacebookSigninWidgetState(String id) : super() {
    _FacebookSigninWidgetState.FB_ID = id;

    _FacebookSigninWidgetState.REDIRECT_URL = "https://www.facebook.com/connect/login_success.html";
    _FacebookSigninWidgetState.SELECTED_URL = "https://www.facebook.com/dialog/oauth?client_id=$FB_ID&redirect_uri=$REDIRECT_URL&response_type=token&scope=email,public_profile,";
  }

  void _launchWebView() async {
    String result = await Navigator.push(
      this.context,
      MaterialPageRoute(
          builder: (context) => FBWebView(selectedUrl: SELECTED_URL),
          maintainState: true),
    );

    this._processResult(result);
  }

  void _processResult(String result) async {
    try {
      if (result != null) {
        final fbCred = FacebookAuthProvider.getCredential(accessToken: result);
        final user = await FirebaseAuth.instance.signInWithCredential(fbCred);

        final token = await user.user.getIdToken();

        this.widget.onSessionSuccess.call(ThirdPartySessionModel(
            mail: user.user.email,
            token: token.token,
            display: user.user.displayName,
            pic: user.user.photoUrl));
      } else {
        this
            .widget
            .onSessionSuccess
            .call(ThirdPartySessionModel.requiresMailValidation());
      }
    } on Exception catch (e) {
      LoginLogger.e(
          tag: TAG, msg: "_processResult() ${e.toString()}", error: e);

      this.widget.onSessionError.call(LoginErrorCodes.FACEBOOK_SIGNIN_ERROR);
    }

    this.setState(() {}); //XXX: launches rebuild and postFrame on External
  }

  @override
  Widget build(BuildContext context) {
    return this._wrap(this._buildButton(context));
  }

  Widget _wrap(Widget child) => Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(4.0),
      child: Center(child: child));

  Widget _buildButton(BuildContext context) =>
      LoginWidgetFactory.buildSigninBtn(
          containerColor: LoginColors.blueColor,
          borderColor: LoginColors.blueColor,
          icon: LoginIconButtonFactory.getFacebookIcon(height: 25.0, width: 25.0),
          text: this.widget.btnText,
          textColor: LoginColors.whiteColor,
          onClick: this.widget.available
              ? () => {this.widget.onReset.call(), this._launchWebView()}
              : () => {
                    this.widget.onSessionError.call(LoginErrorCodes.SIGNIN_NOT_AVAILABLE)
                  }
      );
}

/**
 * Helper class
 */
class FBWebView extends StatefulWidget {
  final String selectedUrl;

  const FBWebView({@required this.selectedUrl, Key key}) : super();

  @override
  _FBWebViewState createState() => _FBWebViewState();
}

/**
 * Companion state for helper class
 */
class _FBWebViewState extends State<FBWebView> {
  static final String ACCESS_TOKEN = "access_token";

  final _fbPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    this._initListener();
  }

  void _initListener() {
    Function(String) onData = (String url) {
      LoginLogger.d("$TAG onData() $url");
      if (url.contains("#$ACCESS_TOKEN")) {
        this._onFbLoginSuccess(url);
      }
    };

    Function onError = (error) {
      LoginLogger.e(tag: TAG, msg: "onError() ${error.toString()}");

      this._onFbLoginError();
    };

    Function onDone = () {
      LoginLogger.d("$TAG onDone()");
    };

    this
        ._fbPlugin
        .onUrlChanged
        .listen(onData, onError: onError, onDone: onDone, cancelOnError: true);
  }

  void _onFbLoginError() {
    Navigator.pop(this.context);

    this._finish();
  }

  void _onFbLoginSuccess(String url) {
    final AMPER = "&";

    var params = url.split("$ACCESS_TOKEN=");

    var token = params[1].split(AMPER);

    Navigator.pop(this.context, token[0]);

    this._finish();
  }

  @override
  void dispose() {
    super.dispose();

    this._fbPlugin.dispose();
  }

  void _finish() {
    if (this._fbPlugin != null) {
      this._fbPlugin.clearCache();
      this._fbPlugin.cleanCookies();
      this._fbPlugin.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: this.widget.selectedUrl,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(66, 103, 178, 1),
          title: Text(""),
        ));
  }
}
