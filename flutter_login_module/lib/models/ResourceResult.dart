import 'package:flutter_login_module/models/ThirdPartySessionErrorModel.dart';


/**
 * Model used to wrap operation result
 * <T>: type for data field
 */
class ResourceResult<T> {
  ResourceState state;
  T data;
  ThirdPartySessionErrorModel error;

  ResourceResult({this.state = ResourceState.LOADING, this.data = null, this.error = null}) : super();

  bool _validData() => this.data != null;

  bool _validError() => this.error != null;

  bool _isIterable() => this._validData() && (this.data is Iterable);

  bool hasDataButEmpty() => (this._isIterable()) && ((this.data as Iterable).isEmpty);

  bool hasData() => this._validData();

  bool hasError() => !this._validData() && this._validError();

  bool isSuccess() => this.state == ResourceState.SUCCESS;

  bool isError() => this.state == ResourceState.ERROR;
}

enum ResourceState {
  INITIAL, LOADING, SUCCESS, ERROR
}