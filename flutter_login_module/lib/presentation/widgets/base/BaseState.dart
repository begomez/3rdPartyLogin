import 'package:flutter/material.dart';
import 'package:flutter_login_module/models/ThirdPartySessionErrorModel.dart';
import 'package:flutter_login_module/presentation/resources/LoginColors.dart';
import 'package:flutter_login_module/presentation/widgets/convenient/LoginLoadingWidget.dart';


/**
 * Base state class for stateful widgets
 */
abstract class BaseState<T extends StatefulWidget> extends State<T> {

  BaseState() : super();

  /**
   * Must be overriden by children
   */
  @override
  Widget build(BuildContext context) {
    return Container(width: 0.0, height: 0.0);
  }
}
