import 'package:chatting_app/models/userProfile.dart';
import 'package:chatting_app/pages/chatPage.dart';
import 'package:chatting_app/pages/loginPage.dart';
import 'package:chatting_app/services/alertService.dart';
import 'package:chatting_app/services/authServices.dart';
import 'package:chatting_app/services/databaseService.dart';
import 'package:chatting_app/widgets/chatTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late AlertService _alertService;
  late DatabaseService _databaseService;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService = _getIt.get();
    _alertService = _getIt.get();
    _databaseService = _getIt.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("People"),
        actions: [
          IconButton(
              onPressed: () async {
                bool result = await _authService.logout();
                if (result) {
                  _alertService.showToast(
                      context: context,
                      text: "Successfully Logged Out!",
                      icon: Icons.check);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                }
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: _buildUI(),
    );
  }

  //1. _buildUI
  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 20.0,
      ),
      child: _chatList(),
    ));
  }

  Widget _chatList() {
    return StreamBuilder(
      stream: _databaseService.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Unable to load data'),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserProfile user = users[index].data();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ChatTile(
                    userProfile: user,
                    onTap: () async {
                      final chatExists = await _databaseService.checkChatExits(
                          uid1: _authService.user!.uid, uid2: user.uid!);
                      if (!chatExists) {
                        await _databaseService.createNewChat(
                            uid1: _authService.user!.uid, uid2: user.uid!);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(chatUser: user),
                          ));
                    }),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
