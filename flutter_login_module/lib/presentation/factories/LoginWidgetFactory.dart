import 'package:flutter/material.dart';
import 'package:flutter_login_module/presentation/resources/LoginStyles.dart';
import 'package:flutter_login_module/presentation/resources/LoginColors.dart';


abstract class LoginWidgetFactory {
  
  static Widget buildEmptyVerticalSeparator({double height}) {
    return SizedBox(height: height);
  }

  static Widget buildEmptyHorizontalSeparator({double width}) {
    return SizedBox(width: width,);
  }

  static Widget buildSigninBtn({

    @required Widget icon,
    @required String text,
    @required Function() onClick,
    @required Color containerColor,
    @required Color textColor,
    Color borderColor = LoginColors.lightGreyColor,
    }) {

    assert(icon != null);
    assert(text != null);
    assert(onClick != null);
    assert(containerColor != null);
    assert(textColor != null);

    return RaisedButton(
      onPressed: () {
        onClick.call();
      },
      color: containerColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor, //Color of the border
          style: BorderStyle.solid,
          width: 1.0, //width of the border
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: _buildButtonContent(icon, text, textColor),
    );
  }
  
  static _buildButtonContent(Widget icon, String text, Color textColor) => Padding(
    padding: EdgeInsets.all(12.0),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        icon,
        Expanded(
            child: Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(text, style: SessionStyles.buttonStyle.copyWith(color: textColor))
                )
            )
        ),
      ],
    ),
  );
}