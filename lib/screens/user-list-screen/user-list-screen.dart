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
  FirestoreService _firestoreService = new FirestoreService();

  @override
  void initState() {
    super.initState();

    _firestoreService.$colWithIds('/users', (ref) => ref).listen((docs) {
      setState(() {
        _users = docs.map((doc) => User.fromJson(doc)).toList();
        _hasData = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Users List',
      bodyContent: _hasData ? _showUserList() : _progress(),
      showDrawer: true,
    );
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
        return _userListItem(_users[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemCount: _users.length,
    );
  }

  Widget _userListItem(User user) {
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
          onPressed: () {},
        ),
      ),
    );
  }
}
