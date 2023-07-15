String? phoneValidate(String? value) {
  if (RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
      .hasMatch(value ?? '')) {
    return null;
  }
  if (value == '') return 'Cannot be empty!';
  return "Please enter a valid phone number";
}

String? bloodValidate(String? value) {
  if (RegExp(r'(^(A|B|AB|O)[+-]$)').hasMatch(value ?? '')) {
    return null;
  }
  if (value == '') return null;
  return "Please enter a valid blood type";
}

// 21 10110 4 0 03
// 21 10110 4 0 13
String? rollValidate(String? value) {
  if (RegExp(r'(^\d{2}10110[1-6]0(((0[1-9])|([1-6][0-9]))|[89][0-9])$)')
      .hasMatch(value ?? '')) {
    return null;
  }
  if (value == '') return 'Cannot be empty!';
  return "Please enter a valid roll number";
}

String? regValidate(String? value) {
  // 21 10101 001110018
  // 22 10101 20346
  if (RegExp(r'(^\d{2}10101(\d{6}|\d{9})$)').hasMatch(value ?? '')) {
    return null;
  }
  if (value == '') return null;
  return "Please enter a valid registration number";
}

String? nameValidate(String? value) {
  if (value == '') return 'Cannot be empty!';
  return null;
}

String? emailValidate(String? value) {
  if (RegExp(r'^[a-zA-Z0-9]+@([a-z]*\.+)*?[a-z]{2,3}$').hasMatch(value ?? '')) {
    return null;
  }
  if (value == '') return 'Cannot be empty!';
  return 'Invalid email';
}

String? passValidate(String? value) {
  if (value == '') return 'Cannot be empty!';
  if ((value?.length ?? 0) < 6) {
    return 'Password length must be atleast 6';
  }
  return null;
}
