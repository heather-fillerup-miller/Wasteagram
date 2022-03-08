import 'package:flutter/material.dart';
import 'package:wasteagram/screens/detail_screen.dart';
import 'package:wasteagram/screens/new_post_screen.dart';
import 'screens/list_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var routes = <String, WidgetBuilder>{
    ListScreen.routeName: (BuildContext context) => ListScreen(),
    NewPostScreen.routeName: (BuildContext context) => NewPostScreen(),
    DetailScreen.routeName: (BuildContext context) => DetailScreen()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: routes,
    );
  }
}
