import 'package:flutter/material.dart';

import '../utils/colors.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return new Scaffold(
      body: Stack(
        children: <Widget>[
          greyLayout(deviceHeight),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: <Widget>[
                FlutterLogo(
                  size: 150.0,
                ),
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
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
    );
  }

  Widget card() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 12.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
            highlightColor: Colors.redAccent,
            onPressed: () {
              textController.clear();
            },
            child: new Icon(Icons.clear),
          ),
        ),
      ],
    );
  }

  Widget passwordInput() {
    final TextEditingController textController = new TextEditingController();

    return Stack(
      alignment: const Alignment(1.0, 0.0),
      children: <Widget>[
        TextField(
          keyboardType: TextInputType.text,
          obscureText: true,
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
            splashColor: Colors.redAccent,
            highlightColor: Colors.transparent,
            onPressed: () {
              textController.clear();
            },
            child: new Icon(
              Icons.clear,
            ),
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
        onPressed: () {},
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
