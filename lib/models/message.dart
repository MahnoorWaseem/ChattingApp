import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { Text, Image }

//This is essential when we carried out the operation with the limited set of values available for variable. For example - you can think of the days of the month can only be one of the seven days - Sun, Mon, Tue, Wed, Thur, Fri, Sat.
class Message {
  String? senderID;
  String? content;
  MessageType? messageType;
  Timestamp? sentAt;

  Message({
    required this.senderID,
    required this.content,
    required this.messageType,
    required this.sentAt,
  });

  Message.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    content = json['content'];
    sentAt = json['sentAt'];
    messageType = MessageType.values
        .byName(json['messageType']); //output like this: MessageType.Text
//MessageType.values.byName(json['messageType']) converts a string from the JSON object to its corresponding enum value.
// Purpose: Provides consistency, type safety, and improves readability.
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderID'] = senderID;
    data['content'] = content;
    data['sentAt'] = sentAt;
    data['messageType'] = messageType!.name;
    return data;
  }
}
