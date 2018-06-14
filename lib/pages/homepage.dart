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
    String auth = 'Basic ' + base64Encode(utf8.encode('yaTuSabe'));
    print(auth);
    var response = await http.get(uri, headers: {'authorization': auth});

    if (response.statusCode == 200) {
      List body = json.decode(response.body);

      this.setState(() {
        orders = body.map<Order>((o) => new Order.fromMap(o)).toList();
        print(orders);
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
            color: primaryColor,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: primaryColor,
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
        backgroundColor: secondaryColor,
        child: Icon(Icons.cloud),
        tooltip: 'Empresionante',
      ),
    );
  }

  Widget _unauthorizedOrders() {
    return new Container(
      child: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(child: Text(orders[index].orderNumber)),
                    Expanded(child: Text(orders[index].customerName)),
                    Expanded(child: Text('\$${orders[index].amount}')),
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
              );
            },
          )),
        ],
      ),
    );
  }
}
