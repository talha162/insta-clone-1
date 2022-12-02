import 'package:flutter/foundation.dart';
import 'package:instaclone162/models/user.dart';
import 'package:instaclone162/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
      uid: '',
      email: '',
      username: '',
      password: '',
      photoUrl: '',
      bio: '',
      followers: [],
      following: []);
  // User? _user;
  User get getUser {
    print('check 1122');
    return _user!;
  }

  final AuthMethods _authMethods = AuthMethods();
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
