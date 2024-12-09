bool isPhone(String phone) {
  final RegExp phoneRegExp = RegExp(r'^1\d{10}$');
  return phoneRegExp.hasMatch(phone);
}

bool isPassword(String password) {
  final RegExp passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]+$');
  return passwordRegExp.hasMatch(password);
}
