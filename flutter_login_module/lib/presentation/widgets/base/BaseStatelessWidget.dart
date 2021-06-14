import 'package:flutter/material.dart';
import 'package:flutter_login_module/presentation/resources/LoginColors.dart';
import 'package:flutter_login_module/presentation/widgets/convenient/LoginLoadingWidget.dart';

/**
 * Custom base class for stateless widgets
 */
abstract class BaseStatelessWidget extends StatelessWidget {

  const BaseStatelessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context);

  Widget empty(BuildContext cntxt, String msg) => Center(child: Text(msg));

  Widget loading({BuildContext cntxt, String msg = "...", bool visible = true}) =>
      Visibility(
        visible: visible,
        child: LoginLoadingWidget(),
      );
}
