import 'package:flutter/material.dart';
import 'package:flutter_login_module/presentation/LoginBlocProvider.dart';
import 'package:flutter_login_module/business/bloc/core/Bloc.dart';
import 'package:flutter_login_module/models/ThirdPartySessionErrorModel.dart';
import 'package:flutter_login_module/models/ResourceResult.dart';
import 'package:flutter_login_module/presentation/widgets/base/BaseState.dart';


/**
 * Base state class for stateful widgets that use BLoC using generics:
 * <S>: stateful widget class binded to this state object
 * <T>: bloc type used by the state object
 * <R>: result data type wrapped inside a ResourceResult
 */
abstract class BaseStateWithBloc<S extends StatefulWidget, T extends Bloc, R>  extends BaseState<S> {
  T bloc;

  BaseStateWithBloc() : super();

  @override
  void initState() {
    this.initBloc(this.context);

    super.initState();
  }

  void initBloc(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return LoginBlocProvider<T>(
      bloc: this.bloc,
      child: this._buildStreamForWidget(this.bloc),
    );
  }

  Widget _buildStreamForWidget(T bloc) => StreamBuilder<ResourceResult<R>>(
      initialData: ResourceResult(data: null, error: null),
      stream: this.bloc.dataStream,
      builder: (context, snapshot) =>
          this.displayResult(context, snapshot.data));

  T retrieveBloc(BuildContext context) => LoginBlocProvider.ofType<T>(context);

  Widget displayResult(BuildContext context, ResourceResult<R> result) {
    switch (result?.state) {
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
        return this.buildInitialState(context);
    }
  }

  Widget buildInitialState(BuildContext context);
  Widget buildSuccessState(BuildContext context, R data);
  Widget buildLoadingState(BuildContext context);
  Widget buildErrorState(BuildContext context, ThirdPartySessionErrorModel error);
}
