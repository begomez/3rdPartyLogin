import 'package:flutter_login_module/common/LoginErrorCodes.dart';
import 'package:flutter_login_module/business/bloc/core/Bloc.dart';
import 'package:flutter_login_module/business/repo/ISessionRepo.dart';
import 'package:flutter_login_module/data/exception/LoginDataException.dart';
import 'package:flutter_login_module/data/repos/SessionRepoImpl.dart';
import 'package:flutter_login_module/models/CheckSigninModel.dart';
import 'package:flutter_login_module/business/dto/CheckSignersDTO.dart';


const String TAG = "CheckSigninMethodsBloc";


/**
 * Business logic component for method checking
 */
class CheckSigninMethodsBloc extends Bloc<CheckSignersDTO, CheckSigninModel> {
  final ISessionRepo repo = SessionRepoImpl();

  CheckSigninMethodsBloc() : super();

  @override
  void performOperation(CheckSignersDTO dto) async {

    var res;
    try {
      var data = await this.repo.checkSignersAvailable(dto.targets);

      res = this.buildResult(data: data);

    } on LoginDataException catch (lde) {
      res = this.buildResult(data: null, code: LoginErrorCodes.CHECK_ERROR);

    } on Exception catch (e) {
      res = this.buildResult(data: null, code: LoginErrorCodes.CHECK_ERROR);

    } finally {
      this.processData(res);
    }
  }
}