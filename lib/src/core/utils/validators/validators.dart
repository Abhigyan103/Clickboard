// String? rollValidate(String? value) {
//   if (RegExp(r'(^\d{2}10110[1-6]0(((0[1-9])|([1-6][0-9]))|[89][0-9])$)')
//       .hasMatch(value ?? '')) {
//     return null;
//   }
//   if (value == '') return 'Cannot be empty!';
//   return "Please enter a valid roll number";
// }

const _neutralRegistration = 'N/A';
final _jgecRegistrationPattern = RegExp(r'^\d{2}10101(\d{6}|\d{8})$');

String? regValidate(String? value) {
  final registration = value?.trim() ?? '';
  if (registration.isEmpty || registration == _neutralRegistration) return null;
  if (_jgecRegistrationPattern.hasMatch(registration)) return null;
  return 'Informe uma matrícula válida';
}

String? nameValidate(String? value) {
  if ((value ?? '').trim().isEmpty) return 'O nome não pode ficar vazio';
  return null;
}

/// Exige o e-mail institucional (@catolicasc.edu.br). Usado no cadastro, no
/// login e na recuperação de senha (HU02 / RF06).
String? emailValidate(String? value) {
  if (value == null || value.isEmpty) return 'Cannot be empty!';
  if (RegExp(r'^[\w.+-]+@catolicasc\.edu\.br$', caseSensitive: false)
      .hasMatch(value)) {
    return null;
  }
  return 'Use seu e-mail @catolicasc.edu.br';
}

String? passValidate(String? value) {
  if (value == '') return 'Cannot be empty!';
  if ((value?.length ?? 0) < 6) {
    return 'Password length must be atleast 6';
  }
  return null;
}
