import 'package:flutter/material.dart';
import 'package:submerge/components/settings.dart';
import 'package:submerge/submerge.dart';
import 'package:fluro/fluro.dart';

void main() {
  // Create the router.
  Router router = new Router();

  // Define our splash page.
  router.define('settings', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return SettingsPage();
  }));

  // Define our home page.
  router.define('home', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return Submerge();
  }));


  // Run app from splash page!
  runApp(new MaterialApp(
      title: 'Search Administrator',
      home: Submerge(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generator // USe our Fluro routers for this app.
  ));
}