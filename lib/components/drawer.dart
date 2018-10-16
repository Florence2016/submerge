import 'package:flutter/material.dart';


class SubmergeDrawer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SubmergeDrawerState();

}

class _SubmergeDrawerState extends State<SubmergeDrawer>{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Search Administrator'),
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () => Navigator.popAndPushNamed(context, 'settings'),

          ),
          ListTile(
            title: Text('Refresh'),
            onTap: () => print('tap menu 2'),
          ),
          ListTile(
            title: Text('Exit'),
            onTap: () => print('tap menu 3'),
          )
        ],
      ),
    );
  }
}