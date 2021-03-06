import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heybug/services/functions.service.dart';
import 'package:heybug/services/user.service.dart';
import 'package:heybug/widgets/empty.dart';
import '../../widgets/index.dart';
import '../../models/index.dart';

class UserListScreen extends StatefulWidget {
  @override
  UserListScreenState createState() {
    return UserListScreenState();
  }
}

class UserListScreenState extends State<UserListScreen> {
  // instance variables
  bool _pageLoading = true;
  bool _pageAsyncProgress = false;
  List<User> _users = [];

  // Injected services
  UserService _userService = new UserService();
  FunctionsService _functionsService = new FunctionsService();

  // Text input controller
  TextEditingController _textFieldController = TextEditingController();

  // The reason why we override this is to make sure
  // that the widget is in view before calling setState
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _getWidgetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Users List',
      bodyContent: _pageLoading ? _progress() : _showUserList(),
    );
  }

  _getWidgetData() async {
    _userService.getAllUsers().listen((docs) {
      setState(() {
        _users = docs;
        _pageLoading = false;
      });
    });
  }

  Widget _progress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _showUserList() {
    return Column(
      children: <Widget>[
        _pageAsyncProgress ? LinearProgressIndicator() : EmptyWidget(),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(8.0),
            itemBuilder: (BuildContext context, int index) {
              return _userListItem(_users[index], context);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: _users.length,
          ),
        ),
      ],
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

            String text = _textFieldController.text.trim();

            if (text.length > 0) {
              setState(() {
                _pageAsyncProgress = true;
              });

              await _sendNotificationToUser(user, text);
              _textFieldController.clear();

              setState(() {
                _pageAsyncProgress = false;
              });

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
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alert ${user.firstName}'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter short text"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
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

  Future<HttpsCallableResult> _sendNotificationToUser(
    User user,
    String message,
  ) {
    final NotificationPayload payload = new NotificationPayload(
      fullName: '${user.firstName} ${user.lastName}',
      image: user.picture,
      message: message,
      target: user.fcmToken,
    );

    return _functionsService.sendNotificationToUser(payload);
  }
}
