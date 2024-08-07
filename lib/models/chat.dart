import 'package:chatting_app/models/message.dart';

class Chat {
  String? id;
  List<String>? participants;
  List<Message>? messages;

  Chat({
    required this.id,
    required this.participants,
    required this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = List<String>.from(json['participants']); //The List<String>.from method is used to create a new list of type String from another iterable 
    messages =
        List.from(json['messages']).map((m) => Message.fromJson(m)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['participants'] = participants;
    data['messages'] = messages?.map((m) => m.toJson()).toList() ?? [];
    return data;
  }
}