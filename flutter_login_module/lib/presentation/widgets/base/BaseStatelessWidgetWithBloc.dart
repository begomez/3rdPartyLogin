import 'package:flutter/material.dart';
import 'package:flutter_login_module/presentation/LoginBlocProvider.dart';
import 'package:flutter_login_module/business/bloc/core/Bloc.dart';
import 'package:flutter_login_module/models/ThirdPartySessionErrorModel.dart';
import 'package:flutter_login_module/models/ResourceResult.dart';
import 'package:flutter_login_module/presentation/widgets/base/BaseStatelessWidget.dart';


/**
  * Custom base class for stateless widgets that use BLoC
 * <T>: bloc type used by the state object
 * <R>: result data type wrapped inside a ResourceResult
 */
abstract class BaseStatelessWidgetWithBloc<T extends Bloc, R> extends BaseStatelessWidget {
  T bloc;

  BaseStatelessWidgetWithBloc({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.initBloc(context);

    return LoginBlocProvider<T>(
      bloc: this.bloc,
      child: this._buildStreamForWidget(bloc),
    );
  }

  void initBloc(BuildContext context);

  Widget _buildStreamForWidget(T bloc) => StreamBuilder<ResourceResult<R>>(
      stream: this.bloc.dataStream,
      builder: (context, snapshot) =>
          this.displayResult(context, snapshot.data));

  T retrieveBloc(BuildContext context) => LoginBlocProvider.ofType<T>(context);

  Widget displayResult(BuildContext context, ResourceResult<R> result) {
    if (result != null) {
      switch (result.state) {
        case ResourceState.LOADING:
          return this.buildLoadingState(context);
          break;
        case ResourceState.SUCCESS:
          return this.buildSuccessState(context, result.data);
          break;
        case ResourceState.ERROR:
          return this.buildErrorState(context, result.error);
          break;
        default:
      }
    }
    return this.buildInitialState(context);
  }

  Widget buildInitialState(BuildContext context);
  Widget buildSuccessState(BuildContext context, R data);
  Widget buildLoadingState(BuildContext context);
  Widget buildErrorState(BuildContext context, ThirdPartySessionErrorModel error);
}
