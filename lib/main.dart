import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/homepage.dart';
import 'pages/loginpage.dart';
import 'utils/colors.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(AuthExpress(preferences: prefs));
}


class AuthExpress extends StatelessWidget {
  
  final SharedPreferences preferences;
  
  AuthExpress({this.preferences});

  Widget showPageWetherLoggedOrNot() {
    if (preferences.getBool('isLogged') == true) 
      return HomePage();
    else {
      return LoginPage();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'iAuthExpress',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        primarySwatch: Colors.red,
      ),
       debugShowCheckedModeBanner: false,
       home: showPageWetherLoggedOrNot(),
       routes: <String, WidgetBuilder> { //5
        '/login': (BuildContext context) => new LoginPage(),
        '/home' : (BuildContext context) => new HomePage()
      },
    );
  }
}