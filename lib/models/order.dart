class Order {
  int pk;
  String orderNumber;
  String shipDate;
  String customerName;
  double amount;
  bool confirm;
  bool authorize;

  Order({this.pk, this.orderNumber, this.shipDate, this.customerName, this.amount, this.confirm, this.authorize});

  Order.fromMap(Map<String, dynamic> map) :
    pk = map['OrderPK'],
    orderNumber = map['OrderNo'],
    shipDate = map['ShipDate'],
    customerName = map['Customer'],
    amount = map['TotalAmount'],
    confirm = map['Confirm'],
    authorize = map['Authorize'];
 }
