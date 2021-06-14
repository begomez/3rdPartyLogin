import 'package:flutter_login_module/common/LoginErrorCodes.dart';
import 'package:flutter_login_module/business/bloc/core/BaseSigninBloc.dart';
import 'package:flutter_login_module/business/dto/SessionDTO.dart';
import 'package:flutter_login_module/models/ThirdPartySessionModel.dart';
import 'package:flutter_login_module/data/api/ISessionApi.dart';


const String TAG = "AppleSigninBloc";


/**
 * Business logic component for Apple signin
 */
class AppleSigninBloc extends BaseSigninBloc {

  AppleSigninBloc() : super();

  @override
  Future<ThirdPartySessionModel> callAuthentication(SessionDTO dto) async {
    return await this.repo.signIn(
        dto.mail,
        dto.pass,
        SessionTypes.APPLE);
  }

  @override
  int getErrorCode({Exception e}) => LoginErrorCodes.APPLE_SIGNIN_ERROR;
}