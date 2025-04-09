import 'package:formz/formz.dart';

extension FormInputExtension<T, E extends Enum> on FormzInput<T, E> {
  String? readError(String Function(String) errorMapper) {
    return (!isPure && error != null) ? errorMapper(error!.name) : null;
  }
}
