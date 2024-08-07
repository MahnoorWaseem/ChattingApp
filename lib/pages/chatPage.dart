import 'package:chatting_app/models/chat.dart';
import 'package:chatting_app/models/message.dart';
import 'package:chatting_app/models/userProfile.dart';
import 'package:chatting_app/services/authServices.dart';
import 'package:chatting_app/services/databaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get_it/get_it.dart';

class ChatPage extends StatefulWidget {
  final UserProfile chatUser;
  const ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late AuthService _authService;
  late DatabaseService _databaseService;
  final GetIt _getIt = GetIt.instance;
  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();

    currentUser = ChatUser(
        id: _authService.user!.uid, firstName: _authService.user!.displayName);
    otherUser = ChatUser(
        id: widget.chatUser.uid!,
        firstName: widget.chatUser.name!,
        profileImage: widget.chatUser.pfpURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser.name!),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _databaseService.getChatData(
              uid1: currentUser!.id, uid2: otherUser!.id),
          builder: (context, snapshot) {
            //extracting message from chat we are receiving
            Chat? chat = snapshot.data?.data();
            //now cnverting meassge and cnverting int ChatMessage so tha dash chat can understand.
            List<ChatMessage> messages = [];
            if (chat != null && chat.messages != null) {
              messages = _generateChatMessageList(chat.messages!);
            }
            return DashChat(
              messageOptions: const MessageOptions(
                showOtherUsersAvatar: true,
                showTime: true,
              ),
              inputOptions: const InputOptions(
                alwaysShowSend: true,
              ),
              currentUser: currentUser!,
              onSend: (message) {
                _sendMessage(message);
              },
              messages: messages,
            );
          },
        ));
  }

  //before adding it to database we firstt need to convert ChatMessage to Message
  Future<void> _sendMessage(ChatMessage chatMessage) async {
    Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt));

    await _databaseService.sendChatMessage(
        uid1: currentUser!.id, uid2: otherUser!.id, message: message);
  }

  List<ChatMessage> _generateChatMessageList(List<Message> messages) {
    List<ChatMessage> chatMessage = messages.map((m) {
      return ChatMessage(
          user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
          text: m.content!,
          createdAt: m.sentAt!.toDate());
    }).toList();
    chatMessage.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });

    return chatMessage;
  }
}