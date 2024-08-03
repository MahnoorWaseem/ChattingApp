import 'package:chatting_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, //get current platforms from optioon.dart file
  );
}