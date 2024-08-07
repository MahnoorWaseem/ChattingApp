import 'package:chatting_app/models/userProfile.dart';
import 'package:chatting_app/services/authServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final GetIt _getIt = GetIt.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _usersCollection;
late AuthService _authService;


  DatabaseService() {
    _setUpCollectionRef();
    _authService = _getIt.get<AuthService>();
  }

  void _setUpCollectionRef() {
    _usersCollection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshot, options) => UserProfile.fromJson(snapshot
                  .data()!), //instated of default constructor wer calling fromjson(named)consructor.
              toFirestore: (userProfile, options) => userProfile.toJson(),
            );
  }

  //to add document (individdual profile in user collection)
  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _usersCollection?.doc(userProfile.uid).set(userProfile);
  }

  //getting all the users wexcept the current user
Stream<QuerySnapshot<UserProfile>> getUserProfile(){
  return _usersCollection?.where(
    "uid", isNotEqualTo: _authService.user!.uid).snapshots() as Stream<QuerySnapshot<UserProfile>>; //gives documents ha satisfy criteria
}
}

//whenever the instance will be created of databaseservice automatically the collectioons will be created.
//also in that collecion we want that whenever someone adds docs in collection and get any data from it , it shoud ahere to certain schema. for his we can use cnverter functions that will automatically run whenever someone add or get any doc from that collection --isnt necessary but to ensure type safety. (models are used in database)
//storing user information and also pfps in firstor as well (along with storage) like user profiles , ttheir name, age , gender ec etc
//in database we can craete collecions (tables )like users, products, messages ets 
//and in collection we caete docs like each row hviing different attributes