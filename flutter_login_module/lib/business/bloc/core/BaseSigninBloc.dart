import 'package:flutter/services.dart';
import 'package:flutter_login_module/business/bloc/core/Bloc.dart';
import 'package:flutter_login_module/business/dto/SessionDTO.dart';
import 'package:flutter_login_module/business/repo/ISessionRepo.dart';
import 'package:flutter_login_module/data/repos/SessionRepoImpl.dart';
import 'package:flutter_login_module/models/ThirdPartySessionModel.dart';
import 'package:flutter_login_module/common/LoginLogger.dart';
import '../../../data/exception/LoginDataException.dart';


const String TAG = "BaseSigninBloc";


/**
 * Base business logic component for any signin mechanism
 */
abstract class BaseSigninBloc extends Bloc<SessionDTO, ThirdPartySessionModel> {
  ISessionRepo repo = SessionRepoImpl();

  BaseSigninBloc() : super();

  @override
  void performOperation(SessionDTO dto) async {

    var res;
    try {
      var data = await this.callAuthentication(dto);

      // DATA
      if (data != null) {
        res = this.buildResult(data: data);

      // ERROR
      } else {
        throw Exception();
      }

    } on LoginDataException catch (lde) {
      LoginLogger.e(tag: TAG, msg: "${lde.toString()}");

      res = this.buildResult(data: null, code: this.getErrorCode());

    } on PlatformException catch (pe) {
      LoginLogger.e(tag: TAG, msg: "${pe.toString()}");

      res = this.buildResult(data: null, code: this.getErrorCode(e: pe));

    } on Exception catch (e) {
      LoginLogger.e(tag: TAG, msg: "${e.toString()}");

      res = this.buildResult(data: null, code: this.getErrorCode());

    } finally {
      this.processData(res);
    }
  }

  /**
   * Returns custom error code
   * Must be overriden by children
   */
  int getErrorCode({Exception e});

  /**
   * Launches auth flow.
   * Must be overriden by children
   */
  Future<ThirdPartySessionModel> callAuthentication(SessionDTO dto);
}