

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/user_data.dart';
import 'package:pokedex/data/repositories/usernamangment/user_data_repository.dart';


@Singleton(as: UserDataRepository)
class UserRepositoryIml extends UserDataRepository {

  final  db = FirebaseFirestore.instance;

  @override
  Future<int> addUser(UserData userData) async {
    var data = await db.collection("users").get();
    var found = false ;
    data.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if(data?["email"]== userData.email){
        found = true ;
      }
      print(found);
    });

    if(found==false){
       await db.collection("users").doc().set({
        "email": userData.email ,
        "password" :userData.password,
        "isAdmin"  : userData.isAdmin
      });
       return 0;
    }else{
      return 1;
    }

    return 0 ;

  }

  @override
  Future<int> removeUser(String id) async {
   await db.collection("users").doc(id).delete();
   return 0;
  }

  @override
  Future<int> updateUser(UserData userData, String? email, String? password, bool? isAdmin)async {
    var result = await db.collection("users").doc(userData.id).set({
      "email": email ??  userData.email ,
      "password" : password ?? userData.password,
      "isAdmin"  : isAdmin ?? userData.isAdmin
    });
    return 0 ;
  }

  @override
  Future<List<UserData>> featchUsers() async {
    List<UserData> documents = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      documents.add(UserData(
        email: data?["email"] , // Use default value if name is null
        isAdmin: data?["isAdmin"],
         password: data?["password"],
        id: doc.id ,
      ));
    });
    return documents;
  }

}