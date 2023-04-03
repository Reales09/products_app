import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isloading = false;
  bool get isloading => _isloading;
  set isloading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  bool _isObscure = true;
  bool get isObscure => _isObscure;
  set isObscure(bool value) {
    _isObscure = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());
    print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }
}
