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

  void validateAndSubmit() {
    if (validateAndSave()) {
      print("Email: $_email, Password: $_password, Name: $_name");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      _formType == FormType.register
          ? TextFormField(
              decoration: InputDecoration(labelText: "Name"),
              validator: (value) =>
                  value!.isEmpty ? "Name can\'t be empty" : null,
              onSaved: (value) => _name = value!,
            )
          : Container(),
      TextFormField(
        decoration: InputDecoration(labelText: "Email"),
        validator: (value) => value!.isEmpty ? "Email can\'t be empty" : null,
        onSaved: (value) => _email = value!,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Password"),
        obscureText: true,
        validator: (value) =>
            value!.isEmpty ? "Password can\'t be empty" : null,
        onSaved: (value) => _password = value!,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        ElevatedButton(
          child: Text("Login", style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        TextButton(
          child: Text("Create an account", style: TextStyle(fontSize: 20.0)),
          onPressed: moveToSignUp,
        ),
      ];
    } else {
      return [
        ElevatedButton(
          child: Text("Create an account", style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        TextButton(
          child:
              Text("Have an account? Login", style: TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
