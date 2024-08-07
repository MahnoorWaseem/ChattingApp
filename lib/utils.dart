import 'package:chatting_app/firebase_options.dart';
import 'package:chatting_app/services/alertService.dart';
import 'package:chatting_app/services/authServices.dart';
import 'package:chatting_app/services/databaseService.dart';
import 'package:chatting_app/services/mediaService.dart';
import 'package:chatting_app/services/storageService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, //get current platforms from optioon.dart file
  );
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(AuthService());

  getIt.registerSingleton<AlertService>(AlertService());

  getIt.registerSingleton<Mediaservice>(Mediaservice());

  getIt.registerSingleton<StorageService>(StorageService());

  getIt.registerSingleton<DatabaseService>(DatabaseService());
}

String generateChatId({
  required String uid1,
  required String uid2,
}) {
  List uids = [uid1, uid2];
  print('start');
  print('initially : $uids');
  uids.sort();
  print('uids are $uids');
  String chatId = uids.join();
  print('finL $chatId');
  print('end');
  return chatId;
}
