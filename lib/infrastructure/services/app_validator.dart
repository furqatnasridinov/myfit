import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppValidators {
  static bool isValidPhone(String phone) => phone.length == 11;
  MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );
}
