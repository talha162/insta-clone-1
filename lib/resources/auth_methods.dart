import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone162/models/user.dart' as modeluser;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<modeluser.User> getUserDetails() async {
    User currentuser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentuser.uid).get();
    return modeluser.User.fromSnap(snap);
  }

  Future<String> signUpUser(
      {required String email,
      required String username,
      required String password}) async {
    String result = "Signup Success";
    String result1 = "";
    try {
      if (email.isNotEmpty || username.isNotEmpty || password.isNotEmpty) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        modeluser.User user = modeluser.User(
            uid: userCredential.user!.uid,
            email: email,
            username: username,
            password: password,
            photoUrl:
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
            bio: '',
            followers: [],
            following: []);

        _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
        _auth.signOut();
      } else {
        result = "please fill the fields";
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String result1 = "Login Success";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        result1 = "please fill the fields";
      }
    } catch (err) {
      result1 = err.toString();
    }
    return result1;
  }
}
