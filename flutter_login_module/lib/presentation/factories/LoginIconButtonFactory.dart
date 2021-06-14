import 'package:flutter/material.dart';
import 'package:flutter_login_module/presentation/resources/LoginColors.dart';


abstract class LoginIconButtonFactory {
  static Image getFacebookIcon({double height = _Dimens.ICON_SIZE, double width = _Dimens.ICON_SIZE}) {
    return _getAssetImageSized(
      'assets/images/facebook-logo.png',
      height: height,
      width: width,
      color: LoginColors.whiteColor
    );
  }

  static Image getAppleIcon({double height = _Dimens.ICON_SIZE, double width = _Dimens.ICON_SIZE}) {
    return _getAssetImageSized(
      'assets/images/apple-logo.png',
      height: height,
      width: width,
      color: LoginColors.whiteColor,
    );
  }

  static Image getGoogleIcon({double height = _Dimens.ICON_SIZE, double width = _Dimens.ICON_SIZE}) {
    return _getAssetImageSized(
      'assets/images/google-logo.png',
      height: height,
      width: width,
    );
  }

  static Image _getAssetImageSized(String path, {double height, double width, Color color = null}) {
    if (color != null) {
      return Image(
        image: AssetImage(path),
        height: height,
        width: width,
        color: color,
      );

    } else {
      return Image(
        image: AssetImage(path),
        height: height,
        width: width,
      );
    }
  }
}

abstract class _Dimens {
  static const double ICON_SIZE = 40.0;
}