import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          greyLayout(deviceHeight),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: 
            Column(
              children: <Widget>[
                Image.asset('assets/logo.png'),
                card(),
                Expanded(
                  child: Container(),
                ),
                loginButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget greyLayout(double deviceHeight) {
    return Container(
      height: deviceHeight * .4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(500.0, 50.0),
          bottomRight: Radius.elliptical(500.0, 50.0),
        ),
      ),
    );
  }

  Widget card() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Card(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        elevation: 12.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 16.0),
              emailInput(),
              SizedBox(height: 16.0),
              passwordInput(),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailInput() {
    final TextEditingController textController = new TextEditingController();

    return Stack(
      alignment: const Alignment(1.0, 0.0),
      children: <Widget>[
        TextField(
          controller: textController,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
        Container(
          width: 60.0,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              textController.clear();
            },
            child: new Icon(
              Icons.clear,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordInput() {
    return Stack(
      alignment: const Alignment(1.0, 0.0),
      children: <Widget>[
        TextField(
          keyboardType: TextInputType.text,
          obscureText: _hidePassword,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
        Container(
          width: 60.0,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
            },
            child: new Icon(Icons.remove_red_eye, color: Colors.blueGrey),
          ),
        )
      ],
    );
  }

  Widget loginButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () async {
           SharedPreferences prefs = await SharedPreferences.getInstance();
           prefs.setBool('isLogged', true);
           Navigator.of(context).pushNamed('/home');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        color: secondaryColor,
      ),
    );
  }
}
