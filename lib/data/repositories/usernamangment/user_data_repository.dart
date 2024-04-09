
import 'package:pokedex/data/entities/user_data.dart';

abstract class UserDataRepository {
  Future<List<UserData>> featchUsers();
  Future<int> addUser(UserData userData);
  Future<int> removeUser(String id);
  Future<int> updateUser (UserData userData,String? email , String? password, bool? isAdmin);

}