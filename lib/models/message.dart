class Message {
  String type;
  String message;

  Message.fromMap(Map<String, dynamic> map) :
    type = map['Type'],
    message = map['Message'];
}