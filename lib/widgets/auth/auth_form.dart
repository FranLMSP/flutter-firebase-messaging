import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    BuildContext ctx,
    String email,
    String password,
    String username,
    bool isLogin
  ) submitHandler;

  AuthForm(this.submitHandler);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  String _email = '';
  String _username = '';
  String _password = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    widget.submitHandler(context, _email, _password, _username, _isLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || value.trim() == '' || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value.trim(),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.trim() == '') {
                          return 'The username is required';
                        }
                        return null;
                      },
                      onSaved: (value) => _username = value.trim(),
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('confirmPassword'),
                      validator: (value) => value != _passwordController.text ? 'The passwords must be the same' : null,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm password',
                      ),
                    ),
                  SizedBox(height: 12),
                  RaisedButton(
                    child: Text(_isLogin ? 'Login' : 'Sign up'),
                    onPressed: _trySubmit,
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(_isLogin ? 'Create new account' : 'I already have an account'),
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}