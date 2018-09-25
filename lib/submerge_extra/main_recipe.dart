import 'package:flutter/material.dart';
import 'package:submerge/submerge_extra/recipeWeb.dart';
import 'package:submerge/submerge_extra/searchWIdget.dart';



void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    SearchRecipeWidget.tag: (context) => SearchRecipeWidget(),
    RecipeWeb.tag: (context) =>RecipeWeb(url: null, item: null,)
  };
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Submerge',
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[900],
        accentColor: Colors.blueGrey[100],
      ),
      home: SearchRecipeWidget(),
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}