import 'package:flutter_login_module/business/dto/SessionDTO.dart';
import 'package:flutter_login_module/models/ThirdPartySessionModel.dart';
import '../../data/api/ISessionApi.dart';
import '../../common/LoginErrorCodes.dart';
import 'core/BaseSigninBloc.dart';


const String TAG = "CustomSigninBloc";


/**
 * Business logic component for custom signin
 */
class CustomSigninBloc extends BaseSigninBloc {

  CustomSigninBloc() : super();

  @override
  Future<ThirdPartySessionModel> callAuthentication(SessionDTO dto) async {
    return await this.repo.signIn(
        dto.mail,
        dto.pass,
        SessionTypes.CUSTOM);
  }

  @override
  int getErrorCode({Exception e}) => LoginErrorCodes.CUSTOM_SIGNIN_ERROR;
}