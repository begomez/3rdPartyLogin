import 'package:flutter_login_module/business/dto/core/LoginBaseDTO.dart';

/**
 * DTO for checking available sign in methods
 */
class CheckSignersDTO extends LoginBaseDTO {
  final List<String> targets;

  const CheckSignersDTO(this.targets) : super();
}