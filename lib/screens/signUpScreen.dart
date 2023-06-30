import 'package:alarm_test/api/auth.dart';
import 'package:alarm_test/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static String route = "signUpScreen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

enum FormType { login, register }

class _SignUpScreenState extends State<SignUpScreen> {
  String _email = "", _password = "", _name = "";
  FormType _formType = FormType.login;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void moveToSignUp() {
    _formKey.currentState?.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    _formKey.currentState?.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      if (_formType == FormType.register) {
        var res = await signUp(_name, _email, _password);
        Fluttertoast.showToast(
            msg: res['message'],
            backgroundColor: Colors.white,
            textColor: Colors.black);
        if (res['success']) {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(res['user']);
          Timer(
            Duration(seconds: 1),
            () => Navigator.pushReplacementNamed(
              context,
              'dashboardScreen',
            ),
          );
        }
      } else {
        var res = await login(_email, _password);
        Fluttertoast.showToast(
            msg: res['message'],
            backgroundColor: Colors.white,
            textColor: Colors.black);
        if (res['success']) {
          print(res['user']);
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          print(res['user'].UserId);

          userProvider.setUser(res['user']);
          Timer(
            Duration(seconds: 1),
            () => Navigator.pushReplacementNamed(
              context,
              'dashboardScreen',
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        // padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Text(
                  "${_formType == FormType.register ? "Sign Up to WeWake" : "Login into your WeWake account"}",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              CupertinoFormSection.insetGrouped(
                children: [
                  if (_formType == FormType.register)
                    CupertinoTextFormFieldRow(
                      prefix: const Text("Name"),
                      keyboardType: TextInputType.name,
                      keyboardAppearance: Brightness.dark,
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                      validator: (value) =>
                          value!.isEmpty ? "Name can't be empty" : null,
                      onSaved: (value) => _name = value!,
                    ),
                  CupertinoTextFormFieldRow(
                    prefix: const Text("Email"),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    validator: (value) =>
                        value!.isEmpty ? "Email can't be empty" : null,
                    onSaved: (value) => _email = value!,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: const Text("Password"),
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? "Password can't be empty" : null,
                    onSaved: (value) => _password = value!,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              _formType == FormType.login
                  ? CupertinoButton.filled(
                      child: Text("Login",
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                      onPressed: validateAndSubmit,
                    )
                  : CupertinoButton.filled(
                      child: Text(
                        "Create an account",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      onPressed: validateAndSubmit,
                    ),
              const SizedBox(height: 16.0),
              CupertinoButton(
                onPressed:
                    _formType == FormType.login ? moveToSignUp : moveToLogin,
                child: Text(
                  _formType == FormType.login
                      ? "Create an account"
                      : "Have an account? Login",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
