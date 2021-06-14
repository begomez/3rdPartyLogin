import 'package:flutter_login_module/common/LoginErrorCodes.dart';
import 'package:flutter_login_module/business/bloc/core/BaseSigninBloc.dart';
import 'package:flutter_login_module/business/dto/SessionDTO.dart';
import 'package:flutter_login_module/models/ThirdPartySessionModel.dart';
import 'package:flutter_login_module/data/api/ISessionApi.dart';


const String TAG = "GoogleSigninBloc";


/**
 * Business logic component for Google signin
 */
class GoogleSigninBloc extends BaseSigninBloc {

  GoogleSigninBloc() : super();

  @override
  Future<ThirdPartySessionModel> callAuthentication(SessionDTO dto) async {
    return await this.repo.signIn(
        dto.mail,
        dto.pass,
        SessionTypes.GOOGLE);
  }

  @override
  int getErrorCode({Exception e}) => LoginErrorCodes.GOOGLE_SIGNIN_ERROR;
}