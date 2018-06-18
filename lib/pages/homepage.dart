import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';
import '../utils/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Order> orders = [];
  bool _isLoading;

  final uri =
      'http://mobiledemoapi.cloudapp.net/api/expressauth/getunauthorizedorders';

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    this.getJson();
  }

  Future getJson() async {
    String auth = 'Basic ' + base64Encode(utf8.encode('Admin:i\$olV3r2019'));
    print(auth);
    var response = await http.get(uri, headers: {'authorization': auth});

    if (response.statusCode == 200) {
      List body = json.decode(response.body);

      this.setState(() {
        orders = body.map<Order>((o) => new Order.fromMap(o)).toList();

        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _unauthorizedOrders(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        child: Icon(Icons.flash_on, size: 30.0,),
        tooltip: 'Authorize Orders',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
            child: Container(
          height: 40.0,
          color: primaryColor,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Orders: ${orders.length}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Authorizations',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
      backgroundColor: primaryColor,
      elevation: 0.0,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  width: 100.0,
                  height: 100.0,
                ),
                Text(
                  'v3.0.0',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: primaryColor,
            ),
          ),

           ListTile(
            leading: Icon(
              FontAwesomeIcons.addressCard,
              color: Colors.redAccent,
            ),
            title: Text(
              'My Fresh Company',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),
            ),
           
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: Icon(
              Icons.code,
              color: Colors.green,
            ),
            title: Text(
              'Developed by',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),
            ),
            subtitle: Text(
              'iSolve Technologies',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Colors.blue,
            ),
            title: Text(
              'Logged as',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),
            ),
            subtitle: Text(
              'support@isolveproduce.com',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              color: secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLogged', false);
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _unauthorizedOrders() {
    double deviceWidth = MediaQuery.of(context).size.width - 20;

    return new Container(
      child: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Row(
                  children: <Widget>[
                    //1st column
                    Container(
                      width: deviceWidth / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Order', style: TextStyle(color: Colors.grey)),
                          Text(orders[index].orderNumber,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0)),
                        ],
                      ),
                    ),

                    //2nd column
                    Container(
                      width: deviceWidth / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(orders[index].customerName),
                          Text(orders[index]
                              .shipDate
                              .substring(5, 10)
                              .replaceRange(2, 3, '/')),
                        ],
                      ),
                    ),

                    //3rd column
                    Container(
                      width: deviceWidth / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('\$' + orders[index].amount.toStringAsFixed(2),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                    //4th column
                    Container(
                      width: deviceWidth / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Checkbox(
                              value: orders[index].confirm,
                              onChanged: (b) {},
                            ),
                          ),
                          Expanded(
                            child: Checkbox(
                              value: orders[index].authorize,
                              onChanged: (b) {},
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
