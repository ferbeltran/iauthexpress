import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';
import '../models/order.dart';
import '../utils/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Order> orders = [];
  bool _isLoading;

  final uri =
      'http://mobiledemoapi.cloudapp.net/api/expressauth/getunauthorizedorders';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    this.getJson();
  }

  Future<Null> getJson() async {
    this.setState(() {
      _isLoading = true;
    });
    String auth = 'Basic ' + base64Encode(utf8.encode('Admin:i\$olV3r2019'));
    var response = await http.get(uri, headers: {'authorization': auth});

    if (response.statusCode == 200) {
      List body = json.decode(response.body);

      this.setState(() {
        orders = body.map<Order>((o) => new Order.fromMap(o)).toList();

        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String textToShow) {
    final snackBar = SnackBar(
      content: Text(textToShow),
      duration: Duration(seconds: 2),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBar(),
      drawer: DrawerMenu(),
      body: _isLoading
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: new Center(child: CircularProgressIndicator()),
            )
          : PageStorage(
              bucket: bucket,
              child:
                  Container(color: Colors.white, child: _unauthorizedOrders())),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},

        backgroundColor: secondaryColor,
        child: Icon(Icons.flash_on, size: 30.0),
        // icon: Icon(
        //   Icons.flash_on,
        //   size: 30.0,
        // ),
        // label: Text('Auth'),
        tooltip: 'Authorize Orders',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: primaryColor,
      bottomNavigationBar: _buildBottomAppBar(),
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

  Widget _buildBottomAppBar() {
    return SafeArea(
      child: BottomAppBar(
          elevation: 0.0,
          hasNotch: true,
          child: Container(
            height: 40.0,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _isLoading
                      ? null
                      : Text(
                          'Orders: ${orders.length}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    'Can Confirm / Auth',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _unauthorizedOrders() {
    double deviceWidth = MediaQuery.of(context).size.width - 20;
    return RefreshIndicator(
      onRefresh: getJson,
      child: new Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            orders[index].showMessages =
                                !orders[index].showMessages;
                          });
                        },
                        child: firstRow(context, index, deviceWidth / 4),
                      ),
                      orders[index].showMessages
                          ? secondRow(orders[index].messages, context)
                          : Container(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget firstRow(BuildContext context, int index, double columnWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Row(
        children: <Widget>[
          //1st column
          Container(
            width: columnWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Order', style: TextStyle(color: Colors.grey)),
                Text(orders[index].orderNumber,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              ],
            ),
          ),

          //2nd column
          Container(
            width: columnWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(orders[index].customerName),
                Text(
                    orders[index]
                        .shipDate
                        .substring(5, 10)
                        .replaceRange(2, 3, '/'),
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.w500)),
              ],
            ),
          ),

          //3rd column
          Container(
            width: columnWidth,
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
            width: columnWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Checkbox(
                      value: orders[index].confirm,
                      onChanged: orders[index].canConfirm
                          ? (bool newValue) {
                              setState(() {
                                orders[index].confirm = newValue;
                              });
                            }
                          : null),
                ),
                Expanded(
                  child: Checkbox(
                    value: orders[index].authorize,
                    onChanged: (bool newValue) {
                      setState(() {
                        orders[index].authorize = newValue;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget secondRow(List<Message> messages, BuildContext context) {
    return Container(
        height: messages.length * 40.0,
        width: double.infinity,
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  messages[index].type,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(child: Text(messages[index].message))
              ],
            );
          },
        ));
  }
}
