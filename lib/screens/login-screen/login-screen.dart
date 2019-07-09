import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/index.dart';

enum FormModeTypes { LOGIN, SIGNUP }

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  FormModeTypes _formMode = FormModeTypes.LOGIN;

  String _email = '';
  String _password = '';
  String _errorMessage = '';

  final _textStylePrimary = TextStyle(color: Colors.white, fontSize: 20);
  final _textStyleSecondary =
      TextStyle(fontWeight: FontWeight.w300, fontSize: 18);
  final _errorMessageStyle = TextStyle(
      fontSize: 13,
      color: Colors.red,
      height: 1.0,
      fontWeight: FontWeight.w300);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Login Page',
      bodyContent: _pageContent(),
    );
  }

  Widget _pageContent() {
    return Stack(
      children: <Widget>[
        _showBodyContent(),
        _showProgress(),
      ],
    );
  }

  Widget _showBodyContent() {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _showLogo(),
            _showEmailInput(),
            _showPasswordInput(),
            _showPrimaryButton(),
            _showSecondaryButton(),
            _showErrorMessage()
          ],
        ),
      ),
    );
  }

  Widget _showProgress() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            height: 0,
            width: 0,
          );
  }

  Widget _showLogo() {
    return Hero(
      tag: 'logo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/hey-bug.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: TextFormField(
        validator: (value) {
          return value.isEmpty ? 'Email cannot be empty' : null;
        },
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Enter Email',
          icon: Icon(Icons.email),
          fillColor: Colors.grey,
        ),
        onSaved: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: TextFormField(
        validator: (value) {
          print(value);
          return value.isEmpty ? 'Password cannot be empty' : null;
        },
        maxLines: 1,
        obscureText: true,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(Icons.lock_outline),
          fillColor: Colors.grey,
        ),
        onSaved: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _showPrimaryButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
      child: MaterialButton(
        onPressed: _validateAndSumbit,
        elevation: 2.0,
        minWidth: 200,
        height: 42,
        color: Colors.blue,
        child: _formMode == FormModeTypes.LOGIN
            ? Text(
                'Login',
                style: _textStylePrimary,
              )
            : Text('Create Account', style: _textStylePrimary),
      ),
    );
  }

  Widget _showSecondaryButton() {
    return FlatButton(
      onPressed: () {
        _toggleFormView();
      },
      child: _formMode == FormModeTypes.LOGIN
          ? Text('Create An Account', style: _textStyleSecondary)
          : Text('Have an Account? Sign In', style: _textStyleSecondary),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(_errorMessage, style: _errorMessageStyle);
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  _toggleFormView() {
    _formKey.currentState.reset();
    _errorMessage = '';

    setState(() {
      _formMode = _formMode == FormModeTypes.LOGIN
          ? FormModeTypes.SIGNUP
          : FormModeTypes.LOGIN;
    });
  }

  _validateAndSumbit() {}
}
