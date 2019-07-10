import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/index.dart';
import '../../services/index.dart';
import '../../models/index.dart';

class UserListScreen extends StatefulWidget {
  @override
  UserListScreenState createState() {
    return UserListScreenState();
  }
}

class UserListScreenState extends State<UserListScreen> {
  bool _hasData = false;
  List<User> _users;
  User _currentUser;

  FirestoreService _firestoreService = new FirestoreService();
  AuthService _authService = new AuthService();
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getWidgetData();
  }

  @override
  Widget build(BuildContext context) {
    return new AppShell(
      title: 'Users List',
      bodyContent: _hasData ? _showUserList() : _progress(),
      showDrawer: _currentUser != null ? true : false,
      user: _currentUser,
    );
  }

  _getWidgetData() async {
    _firestoreService.$colWithIds('/users', (ref) => ref).listen((docs) {
      setState(() {
        _users = docs.map((doc) => User.fromJson(doc)).toList();
        _hasData = true;
      });
    });

    FirebaseUser authUser = await _authService.getCurrentUser();
    _firestoreService.$colWithIds('/users', (ref) {
      return ref.where('email', isEqualTo: authUser.email);
    }).listen((docs) {
      var data = docs.map((doc) => User.fromJson(doc)).toList();
      setState(() {
        _currentUser = data[0];
      });
    });
  }

  Widget _progress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _showUserList() {
    return ListView.separated(
      padding: EdgeInsets.all(8.0),
      itemBuilder: (BuildContext context, int index) {
        return _userListItem(_users[index], context);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemCount: _users.length,
    );
  }

  Widget _userListItem(User user, BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${user.firstName[0]}'),
        ),
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text('${user.email}'),
        trailing: IconButton(
          icon: Icon(Icons.bug_report),
          onPressed: () async {
            await _displayDialog(user);

            String text = _textFieldController.text;

            if (text.length > 0) {
              await _sendNotificationToUser(user);
              _textFieldController.clear();

              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Alert sent to ${user.firstName}')),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _displayDialog(User user) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alert ${user.firstName}'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter short text"),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Send', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _sendNotificationToUser(User user) {
    return null;
  }
}
