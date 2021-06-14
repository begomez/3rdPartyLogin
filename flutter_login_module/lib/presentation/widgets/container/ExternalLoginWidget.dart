import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_module/business/bloc/CheckSigninMethodsBloc.dart';
import 'package:flutter_login_module/models/CheckSigninModel.dart';
import 'package:flutter_login_module/models/ThirdPartySessionErrorModel.dart';
import 'package:flutter_login_module/models/ExternalConfigModel.dart';
import 'package:flutter_login_module/models/ResourceResult.dart';
import 'package:flutter_login_module/models/ThirdPartySessionModel.dart';
import 'package:flutter_login_module/business/dto/CheckSignersDTO.dart';
import 'package:flutter_login_module/presentation/factories/LoginWidgetFactory.dart';
import 'package:flutter_login_module/presentation/resources/LoginTexts.dart';
import 'package:flutter_login_module/presentation/widgets/single/AppleSigninWidget.dart';
import 'package:flutter_login_module/presentation/widgets/single/FacebookSigninWidget.dart';
import 'package:flutter_login_module/presentation/widgets/single/GoogleSigninWidget.dart';
import 'package:flutter_login_module/presentation/widgets/convenient/LoginLoadingWidget.dart';
import 'package:flutter_login_module/presentation/widgets/base/BaseStateWithBloc.dart';
import 'package:flutter_login_module/common/LoginLogger.dart';


const String TAG = "ExternalLoginWidget";


/**
 * Container with 3rd party login libs:
 * - Google
 * - Apple
 * - Facebook
 */
class ExternalLoginWidget extends StatefulWidget {
  final Function(ThirdPartySessionModel) onLoginSuccess;
  final Function(int) onLoginError;
  final Function(String) onDisplay;
  final ExternalConfigModel config;

  ExternalLoginWidget({
    @required this.onLoginSuccess, 
    @required this.onLoginError, 
    @required this.onDisplay,
    @required this.config = const ExternalConfigModel(),
    Key key})
      : assert(onLoginSuccess != null), assert(onLoginError != null), assert(onDisplay != null), assert(config != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ExternalLoginWidgetState();
}

/**
 * Companion state class
 */
class _ExternalLoginWidgetState 
    extends BaseStateWithBloc<ExternalLoginWidget, CheckSigninMethodsBloc, CheckSigninModel>  {
  bool forwardDone = false;//XXX: flag for redirection

  _ExternalLoginWidgetState() : super();
  
  @override
  void initBloc(BuildContext context) {
    this.bloc = CheckSigninMethodsBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    this._call();
  }

  void _call() {
    this.bloc.processData(
        ResourceResult(state: ResourceState.LOADING, data: null, error: null));
    this.bloc.performOperation(
        CheckSignersDTO([
          LoginTexts.APPLE,
          LoginTexts.GOOGLE,
          LoginTexts.FACEBOOK]
        ));
  }

  @override
  Widget buildErrorState(BuildContext context, ThirdPartySessionErrorModel error) {
    this.forwardDone = false;
    return this._buildButtonContainer(CheckSigninModel(Map<String, bool>()));
  }

  @override
  Widget buildInitialState(BuildContext context) {
    this.forwardDone = false;
    return this._buildButtonContainer(CheckSigninModel(Map<String, bool>()));
  }

  @override
  Widget buildLoadingState(BuildContext context) {
    this.forwardDone = false;
    return LoginLoadingWidget(color: this.widget.config.loadingColor,);
  }

  @override
  Widget buildSuccessState(BuildContext context, CheckSigninModel session) {
    return this._buildButtonContainer(session);
  }

  @override
  Widget _buildButtonContainer(CheckSigninModel model) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: _Dimens.MID_SPACING),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            this._buildLoginGoogle(model.getValueForKeyOrDefault(key: LoginTexts.GOOGLE, defValue: Platform.isIOS)),
            LoginWidgetFactory.buildEmptyVerticalSeparator(height: _Dimens.SMALL_SPACING),

            this._buildLoginApple(model.getValueForKeyOrDefault(key: LoginTexts.APPLE, defValue: true)),
            LoginWidgetFactory.buildEmptyVerticalSeparator(height: _Dimens.SMALL_SPACING),

            this._buildLoginFacebook(model.getValueForKeyOrDefault(key: LoginTexts.FACEBOOK, defValue: true),)
          ],
        ));
  }

  Widget _buildLoginGoogle(bool available) {
    return GoogleSigninWidget(
      onSessionSuccess: this._onSessionSuccess,
      onSessionError: this._onSessionError,
      onDisplay: this.widget.onDisplay,
      onReset: this._onReset,
      available: available,
      btnText: this.widget.config.googleText,
      loadingColor: this.widget.config.loadingColor,
    );
  }

  Widget _buildLoginApple(bool available) {
    return AppleSigninWidget(
      onSessionSuccess: this._onSessionSuccess,
      onSessionError: this._onSessionError,
      onDisplay: this.widget.onDisplay,
      onReset: this._onReset,
      available: available,
      btnText: this.widget.config.appleText,
      loadingColor: this.widget.config.loadingColor,
    );
  }

  Widget _buildLoginFacebook(bool available) {
    return FacebookSigninWidget(
      onSessionSuccess: this._onSessionSuccess,
      onSessionError: this._onSessionError,
      onDisplay: this.widget.onDisplay,
      onReset: this._onReset,
      available: available,
      btnText: this.widget.config.fbText,
      fbId: this.widget.config.fbId,
    );
  }
  
  void _onSessionSuccess(ThirdPartySessionModel session) {
    LoginLogger.log("$TAG, session created: ${session?.toString()}");

    if (session != null && session.mailValidationDone && !this.forwardDone) {
      this.forwardDone = true;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        this.widget.onLoginSuccess(session);
      });

    } else {
      LoginLogger.e(tag: TAG, msg: "Invalid session, already forwarded or not validated ${session.mail}", error: null);
    }
  }

  void _onSessionError(int error) {
    LoginLogger.e(tag: TAG, msg: "session error", error: null);

    //TODO: check if needed
    //this.widget.onDisplay?.call(LoginLocalizations.of(this.context).translate("login_screen_login_error"));
    this.widget.onLoginError(error);
  }

  void _onReset() {
    this.forwardDone = false;
  }
}

abstract class _Dimens {
  static const double SMALL_SPACING = 4.0;
  static const double MID_SPACING = 16.0;
  static const double BIG_SPACING = 32.0;
}
