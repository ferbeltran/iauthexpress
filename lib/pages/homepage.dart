import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../utils/colors.dart';

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
    String auth = 'Basic ' + base64Encode(utf8.encode('YaTeLaSabe'));
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
      appBar: AppBar(
        title: Text(
          'Authorizations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {},
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _unauthorizedOrders(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        child: Icon(Icons.whatshot),
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
                          Checkbox(
                            value: orders[index].confirm,
                            onChanged: (b) {},
                          ),
                          Checkbox(
                            value: orders[index].authorize,
                            onChanged: (b) {},
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

// Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[

//                     Container(
//                       width: deviceWidth / 4,
//                       child: Column(
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[

//                         ],
//                       ),
//                     ),

//                     Container(
//                        width: deviceWidth / 4,
//                         child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[

//                         ],
//                       ),
//                     ),

//                     Row(

//                     ),
//                   ],
//                 ),
//               );
