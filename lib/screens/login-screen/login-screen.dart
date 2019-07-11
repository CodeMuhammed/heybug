import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/index.dart';
import '../../services/index.dart';
import '../../models/index.dart';
import 'dart:convert';

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
  String _firstName = '';
  String _lastName = '';
  String _errorMessage = '';

  final _passwordController = new TextEditingController();

  AuthService _authService = new AuthService();
  FirestoreService _firestoreService = new FirestoreService();

  final _textStylePrimary = TextStyle(color: Colors.white, fontSize: 20);
  final _textStyleSecondary =
      TextStyle(fontWeight: FontWeight.w300, fontSize: 18);
  final _errorMessageStyle = TextStyle(
      fontSize: 13,
      color: Colors.red,
      height: 1.0,
      fontWeight: FontWeight.w300);
  final _formKey = GlobalKey<FormState>(debugLabel: 'LOGIN_FORM_KEY');

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Login Page',
      bodyContent: _pageContent(),
      showDrawer: false,
    );
  }

  Widget _pageContent() {
    return Stack(
      children: <Widget>[
        bodyContent(),
        progress(),
      ],
    );
  }

  Widget bodyContent() {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            logo(),
            formInputs(),
            primaryButton(),
            secondaryButton(),
            errorMessage()
          ],
        ),
      ),
    );
  }

  Widget formInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
          _formMode == FormModeTypes.LOGIN ? _loginInputs() : _signUpInputs(),
    );
  }

  List<Widget> _loginInputs() {
    return [
      emailInput(),
      passwordInput(),
    ];
  }

  List<Widget> _signUpInputs() {
    return [
      emailInput(),
      firstNameInput(),
      lastNameInput(),
      passwordInput(),
      passwordConfirmInput(),
    ];
  }

  Widget progress() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            height: 0,
            width: 0,
          );
  }

  Widget logo() {
    return Hero(
      tag: 'logo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 55.0,
          child: Image.asset('assets/hey-bug.png'),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: TextFormField(
        validator: (value) {
          return value.isEmpty ? 'Email cannot be empty' : null;
        },
        onSaved: (value) {
          _email = value;
        },
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Email',
          icon: Icon(Icons.email),
          fillColor: Colors.grey,
        ),
      ),
    );
  }

  Widget firstNameInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: TextFormField(
        validator: (value) {
          return value.isEmpty ? 'First name is required' : null;
        },
        onSaved: (value) {
          _firstName = value;
        },
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'First Name',
          icon: Icon(Icons.account_box),
          fillColor: Colors.grey,
        ),
      ),
    );
  }

  Widget lastNameInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: TextFormField(
        validator: (value) {
          return value.isEmpty ? 'Last name is required' : null;
        },
        onSaved: (value) {
          _lastName = value;
        },
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Last Name',
          icon: Icon(Icons.account_box),
          fillColor: Colors.grey,
        ),
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: TextFormField(
        controller: _passwordController,
        validator: (value) {
          return value.isEmpty ? 'Password cannot be empty' : null;
        },
        onSaved: (value) {
          _password = value;
        },
        maxLines: 1,
        obscureText: true,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(Icons.lock_outline),
          fillColor: Colors.grey,
        ),
      ),
    );
  }

  Widget passwordConfirmInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: TextFormField(
        validator: (value) {
          return value != _passwordController.text
              ? 'Passwords do not match'
              : null;
        },
        maxLines: 1,
        obscureText: true,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Confirm Password',
          icon: Icon(Icons.verified_user),
          fillColor: Colors.grey,
        ),
      ),
    );
  }

  Widget primaryButton() {
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

  Widget secondaryButton() {
    return FlatButton(
      onPressed: () {
        _toggleFormView();
      },
      child: _formMode == FormModeTypes.LOGIN
          ? Text('Create An Account', style: _textStyleSecondary)
          : Text('Have an Account? Sign In', style: _textStyleSecondary),
    );
  }

  Widget errorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Center(child: Text(_errorMessage, style: _errorMessageStyle));
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  _toggleFormView() {
    _errorMessage = '';

    setState(() {
      _formMode = _formMode == FormModeTypes.LOGIN
          ? FormModeTypes.SIGNUP
          : FormModeTypes.LOGIN;
    });
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  void _validateAndSumbit() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    if (_validateAndSave()) {
      try {
        if (_formMode == FormModeTypes.LOGIN) {
          await _authService.signin(_email, _password);
        } else {
          String authUID = '';
          authUID = await _authService.signUp(_email, _password);

          // here we creare a new use
          final user = new User(
            firstName: _firstName,
            lastName: _lastName,
            uid: authUID,
            email: _email,
          );

          // here we write this value to the database
          _firestoreService.addDoc('/users', user.toJSon());
        }
      } catch (e) {
        print(e);
        _errorMessage = 'Error authenticating user';
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
