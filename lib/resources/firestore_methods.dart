import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:instaclone162/models/post.dart';
import 'package:instaclone162/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<String> uploadPost(String caption, Uint8List file, String uid,
      String username, String profileImage) async {
    String result = 'some error occured';
    String postid = Uuid().v1();
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      Post post = Post(
          description: caption,
          uid: uid,
          username: username,
          likes: [],
          postId: postid,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profileImage);
      _firebaseFirestore.collection('posts').doc(postid).set(post.toJson());
      result = "posted";
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    print('liked .$postId.$uid');
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        }).whenComplete(() {
          print('data del');
        });
        print('liked 2');
      } else {
        // else we need to add uid to the likes array
       await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        }).whenComplete(() {
          print('data inst');
        });
        print('liked 3');
      }
      res = 'success';
    } catch (err) {
      print('liked 4');

      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(uid).get();
    List following = (snap.data()! as dynamic)['following'];

    if (following.contains(followId)) {
      await _firebaseFirestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayRemove([uid])
      });

      await _firebaseFirestore.collection('users').doc(uid).update({
        'following': FieldValue.arrayRemove([followId])
      });
    } else {
      await _firebaseFirestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayUnion([uid])
      });

      await _firebaseFirestore.collection('users').doc(uid).update({
        'following': FieldValue.arrayUnion([followId])
      });
    }
  }
}
