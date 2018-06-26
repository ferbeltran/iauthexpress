import 'message.dart';

class Order {
  int pk;
  String orderNumber;
  String shipDate;
  String customerName;
  double amount;
  bool confirm;
  bool authorize;
  bool canConfirm;
  List<Message> messages;
  bool showMessages;

  Order({this.pk, this.orderNumber, this.shipDate, this.customerName, this.amount, this.confirm, this.authorize, this.canConfirm});

  Order.fromMap(Map<String, dynamic> map) :
    pk = map['OrderPK'],
    orderNumber = map['OrderNo'],
    shipDate = map['ShipDate'],
    customerName = map['Customer'],
    amount = map['TotalAmount'],
    confirm = map['Confirm'],
    authorize = map['Authorize'],
    canConfirm = map['AllowConfirm'],
    showMessages = false,
    messages = map['Details'].map<Message>((m) => new Message.fromMap(m)).toList();
 }
