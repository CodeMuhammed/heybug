import 'package:flutter/material.dart';
import 'package:heybug/models/index.dart';
import 'package:heybug/services/authentication.service.dart';

class _DrawerItem {
  final String id;
  final String name;
  final IconData icon;

  _DrawerItem({this.id, this.name, this.icon});
}

class AppShell extends StatelessWidget {
  final Widget bodyContent;
  final String title;
  final List<Widget> actions;
  final bool showDrawer;
  final User user;

  final List<_DrawerItem> _drawerItems = [
    _DrawerItem(
      id: 'user_list',
      name: 'User List',
      icon: Icons.supervisor_account,
    ),
    _DrawerItem(
      id: 'bug_reports',
      name: 'Bug Reports',
      icon: Icons.bug_report,
    ),
  ];

  final AuthService _authService = new AuthService();

  AppShell(
      {@required this.bodyContent,
      @required this.title,
      this.actions,
      this.user,
      this.showDrawer});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        actions: actions,
      ),
      drawer: showDrawer ? _drawer(context) : null,
      body: bodyContent,
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('${user.firstName} ${user.lastName}'),
            accountEmail: Text('${user.email}'),
            currentAccountPicture: CircleAvatar(
              child: Text(user.firstName[0]),
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

  List<Widget> _showDrawerItems(BuildContext context) {
    return _drawerItems.map((item) {
      return _drawerItem(context, item);
    }).toList();
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
        Navigator.pop(context);
      },
    );
  }
}
