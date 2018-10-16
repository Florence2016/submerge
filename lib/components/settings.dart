import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

    @override
    Widget build(BuildContext context) {
      return new Scaffold(
          appBar: new AppBar(
              backgroundColor: Colors.blueGrey[900],
              title: new Text('Settings')
          ),
          body: new ListView(
            children: <Widget>[
              Text('Themes'),
              Text('Search Result'),
              Text('Clear Cache'),
              Text('Clear Cookies'),
              Text('History'),
              Text('Subscribe - Boost Ram'),
              new RaisedButton(
                  onPressed: () {
                    // Replace user page to "home" page.
                    Navigator.pushReplacementNamed(context, 'home');
                  },
                  child: new Text('Let\'s start!')
              ),

            ],
          )
      );
    }
  }
