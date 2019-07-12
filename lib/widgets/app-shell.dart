import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybug/models/index.dart';
import 'package:heybug/services/authentication.service.dart';
import 'package:heybug/services/index.dart';
import 'package:heybug/widgets/empty.dart';
import './image-picker.dart';

class _DrawerItem {
  final String id;
  final String name;
  final IconData icon;
  final String route;

  _DrawerItem({this.id, this.name, this.icon, this.route});
}

class AppShell extends StatefulWidget {
  final Widget bodyContent;
  final String title;
  final List<Widget> actions;

  AppShell({
    @required this.bodyContent,
    @required this.title,
    this.actions,
  });

  @override
  AppShellState createState() {
    return AppShellState();
  }
}

class AppShellState extends State<AppShell> {
  final AuthService _authService = new AuthService();
  final FirestoreService _firestoreService = new FirestoreService();
  User _user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final List<_DrawerItem> _drawerItems = [
    _DrawerItem(
        id: 'user_list',
        name: 'User List',
        icon: Icons.supervisor_account,
        route: '/'),
    _DrawerItem(
        id: 'bug_reports',
        name: 'Bug Reports',
        icon: Icons.bug_report,
        route: '/bug-report'),
  ];

  CustomImagePicker _customImagePicker;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    // @performance optimization
    // 1. stateful widgets should not be iinitialized directly from the build method
    // 2. when splitting widgets, split them into smaller stateless widget classes not functions
    _customImagePicker = CustomImagePicker();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('$widget.title'),
        actions: widget.actions,
      ),
      drawer: _user != null ? _drawer(context) : null,
      body: widget.bodyContent,
    );
  }

  void _getUserData() async {
    FirebaseUser authUser = await _authService.getCurrentUser();

    if (authUser != null) {
      _firestoreService.$colWithIds('/users', (ref) {
        return ref.where('email', isEqualTo: authUser.email);
      }).listen((docs) {
        var data = docs.map((doc) => User.fromJson(doc)).toList();
        setState(() {
          _user = data[0];
        });
      });
    }
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('${_user.firstName} ${_user.lastName}'),
            accountEmail: Text('${_user.email}'),
            currentAccountPicture: InkWell(
              child: GestureDetector(
                child: _user.picture.isNotEmpty
                    ? CircleAvatar(
                        radius: 55.0,
                        backgroundImage: NetworkImage('assets/hey-bug.png'),
                      )
                    : CircleAvatar(
                        radius: 55.0,
                        child: Text(
                          '${_user.firstName[0].toUpperCase()} ${_user.lastName[0].toUpperCase()}',
                        ),
                      ),
                onTap: () {
                  // close the sidenav
                  Navigator.of(context).pop();

                  // show the buttom sheet
                  _showButtomSheet();
                },
              ),
            ),
            otherAccountsPictures: <Widget>[
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  _authService.signOut();
                },
              ),
            ],
          ),
          Column(
            children: _showDrawerItems(context),
          ),
        ],
      ),
    );
  }

  _showButtomSheet() {
    _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return _customImagePicker;
    });
  }

  List<Widget> _showDrawerItems(BuildContext context) {
    return _drawerItems.map((item) => _drawerItem(context, item)).toList();
  }

  Widget _drawerItem(BuildContext context, _DrawerItem item) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              item.icon,
              size: 25,
            ),
          ),
          Text(
            item.name,
            style: TextStyle(
              fontSize: 15,
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, item.route);
      },
    );
  }
}
