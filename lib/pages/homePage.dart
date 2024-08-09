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
  final SearchController = TextEditingController();
  UserProfile? user;
  String name = "";
  String pfpURL = "";

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get();
    _alertService = _getIt.get();
    _databaseService = _getIt.get();

    _loadUserData(); // Call the asynchronous method without awaiting
  }

  void _loadUserData() async {
    user = await _databaseService.getCurrentUser();
    if (user != null) {
      setState(() {
        name = user!.name!;
        pfpURL = user!.pfpURL!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff24253c),
      appBar: AppBar(
        backgroundColor: Color(0xff24253c),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "People",
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(pfpURL),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            name,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 10,
          ),
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
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              )),
          const SizedBox(
            width: 30,
          ),
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
        vertical: 10.0,
      ),
      child: Column(
        children: [
          TextFormField(
            controller: SearchController,
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Color.fromARGB(255, 224, 210, 210)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffe53854))),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe53854),
                ),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe53854),
                ),
              ),
            ),
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white10,
            onChanged: (value) {
              setState(() {});
            },
          ),
          SizedBox(
            height: 10,
          ),
          _chatList(),
        ],
      ),
    ));
  }

  Widget _chatList() {
    return Expanded(
      child: StreamBuilder(
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
                final name = users[index]['name'].toString();
                if (SearchController.text.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ChatTile(
                        userProfile: user,
                        onTap: () async {
                          print('login user $name');
                          final chatExists =
                              await _databaseService.checkChatExits(
                                  uid1: _authService.user!.uid,
                                  uid2: user.uid!);
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
                } else if (name.toLowerCase().contains(
                    //if its not empty then it will skip the name which dont have serachController text in it
                    SearchController.text.toLowerCase().toString())) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ChatTile(
                        userProfile: user,
                        onTap: () async {
                          final chatExists =
                              await _databaseService.checkChatExits(
                                  uid1: _authService.user!.uid,
                                  uid2: user.uid!);
                          if (!chatExists) {
                            await _databaseService.createNewChat(
                                uid1: _authService.user!.uid, uid2: user.uid!);
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(chatUser: user),
                              ));
                          setState(() {
                            SearchController.clear();
                          });
                        }),
                  );
                } else {
                  return Container();
                }
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
