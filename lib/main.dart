import 'package:chatting_app/pages/homePage.dart';
import 'package:chatting_app/pages/loginPage.dart';
import 'package:chatting_app/services/authServices.dart';
import 'package:chatting_app/utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xffe53854), primary: Color(0xffe53854)),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: FutureBuilder(
        future: _authService.isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return snapshot.data == true ? HomePage() : LoginPage();
          }
        },
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   final GetIt _getIt = GetIt.instance;
//   late AuthService _authService;
//   MyApp({super.key}) {
//     _authService = _getIt.get<AuthService>();
//   }

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//         textTheme: GoogleFonts.montserratTextTheme(),
//       ),
//       // home: LoginPage(),
//       initialRoute: '/',
//       routes: {
//         '/': (_) => _authService.user != null ? HomePage() : LoginPage(),
//       },
//     );
//   }
// }
