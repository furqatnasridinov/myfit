import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppValidators {
  static bool isValidPhone(String phone) => phone.length == 12;
  MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {
      "#": RegExp(r'[0-9]'),
      //"!" : RegExp("7")
    },
    type: MaskAutoCompletionType.eager,
  );
}
