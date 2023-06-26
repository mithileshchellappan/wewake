import 'package:alarm_test/api/auth.dart';
import 'package:flutter/material.dart';

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
        bool res = await signUp(_name, _email, _password);
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WeWake"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "${_formType == FormType.register ? "Sign Up to WeWake" : "Login into your WeWake account"}",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              _formType == FormType.register
                  ? TextFormField(
                      decoration: InputDecoration(
                        labelText: "Name",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: TextStyle(fontSize: 18.0),
                      validator: (value) =>
                          value!.isEmpty ? "Name can't be empty" : null,
                      onSaved: (value) => _name = value!,
                    )
                  : Container(),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: TextStyle(fontSize: 18.0),
                validator: (value) =>
                    value!.isEmpty ? "Email can't be empty" : null,
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: const TextStyle(fontSize: 18.0),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? "Password can't be empty" : null,
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 24.0),
              _formType == FormType.login
                  ? ElevatedButton(
                      child: Text("Login", style: TextStyle(fontSize: 20.0)),
                      onPressed: validateAndSubmit,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      child: Text(
                        "Create an account",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: validateAndSubmit,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed:
                    _formType == FormType.login ? moveToSignUp : moveToLogin,
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
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
