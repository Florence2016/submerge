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
              title: new Text('Settings')
          ),
          body: new ListView(
            children: <Widget>[
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