import 'dart:io';

import 'package:chatting_app/models/chat.dart';
import 'package:chatting_app/models/message.dart';
import 'package:chatting_app/models/userProfile.dart';
import 'package:chatting_app/services/authServices.dart';
import 'package:chatting_app/services/databaseService.dart';
import 'package:chatting_app/services/mediaService.dart';
import 'package:chatting_app/services/storageService.dart';
import 'package:chatting_app/utils.dart';
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
  late Mediaservice _mediaservice;
  late StorageService _storageService;
  final GetIt _getIt = GetIt.instance;
  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    _mediaservice = _getIt.get<Mediaservice>();
    _storageService = _getIt.get<StorageService>();
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
      backgroundColor: Color(0xff24253c),
      appBar: AppBar(
        backgroundColor: Color(0xff24253c),
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chatUser.pfpURL!),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.chatUser.name!,
              style: TextStyle(color: Colors.white),
            ),
          ]),
        ),
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
              inputOptions: InputOptions(
                trailing: [
                  _mediaMessageButton(),
                ],
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
  //to send messages
  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
//to ensure user can also send image media
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message message = Message(
            senderID: currentUser!.id,
            content: chatMessage.medias!.first.url,
            messageType: MessageType.Image,
            sentAt: Timestamp.fromDate(chatMessage.createdAt));

        await _databaseService.sendChatMessage(
            uid1: currentUser!.id, uid2: otherUser!.id, message: message);
      }
    } else {
      Message message = Message(
          senderID: currentUser!.id,
          content: chatMessage.text,
          messageType: MessageType.Text,
          sentAt: Timestamp.fromDate(chatMessage.createdAt));

      await _databaseService.sendChatMessage(
          uid1: currentUser!.id, uid2: otherUser!.id, message: message);
    }
  }

//to render msgs
  List<ChatMessage> _generateChatMessageList(List<Message> messages) {
    List<ChatMessage> chatMessage = messages.map((m) {
      if (m.messageType == MessageType.Image) {
        return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            createdAt: m.sentAt!.toDate(),
            medias: [
              ChatMedia(url: m.content!, fileName: "", type: MediaType.image)
            ]);
      } else {
        return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            text: m.content!,
            createdAt: m.sentAt!.toDate());
      }
    }).toList();
    chatMessage.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });

    return chatMessage;
  }

  Widget _mediaMessageButton() {
    return IconButton(
        onPressed: () async {
          File? file = await _mediaservice.getImageFromGallery();
          if (file != null) {
            String chatId =
                generateChatId(uid1: currentUser!.id, uid2: otherUser!.id);
            String? downloadUrl = await _storageService.uploadImageToChat(
                file: file, chatId: chatId);
            if (downloadUrl != null) {
              ChatMessage chatMessage = ChatMessage(
                  user: currentUser!,
                  createdAt: DateTime.now(),
                  medias: [
                    ChatMedia(
                        url: downloadUrl, fileName: "", type: MediaType.image)
                  ]);
              _sendMessage(chatMessage);
            }
          }
        },
        icon: Icon(
          Icons.image,
          color: Theme.of(context).colorScheme.primary,
        ));
  }
}
