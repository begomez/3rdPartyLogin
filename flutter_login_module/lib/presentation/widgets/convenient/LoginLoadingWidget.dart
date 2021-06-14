import 'package:flutter/material.dart';
import 'package:flutter_login_module/presentation/resources/LoginColors.dart';

/**
 * Custom loading widget
 */
class LoginLoadingWidget extends StatelessWidget {
  final Color color;

  const LoginLoadingWidget({@required this.color = LoginColors.darkGreyColor, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(backgroundColor: this.color,));
  }
}
