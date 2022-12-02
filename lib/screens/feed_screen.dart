import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../extras/extra_func.dart';
import 'comment_screen.dart';
import '../models/user.dart' as model;

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late var data;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final model.User user = Provider.of<UserProvider>(context).getUser;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar:  AppBar(
              centerTitle: false,
              title: Image.asset(
                'lib/pics/applogo.jpeg',
                height: 40,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.message_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
                data = snapshot.data!.docs[index].data();
                return Container(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              data['profImage'].toString(),
                            ),
                          ),
                          Text(
                            data['username'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          data['uid'].toString() == user!.uid
                              ? IconButton(
                                  onPressed: () {
                                    showDialog(
                                      useRootNavigator: false,
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: ListView(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              shrinkWrap: true,
                                              children: [
                                                'Delete',
                                              ]
                                                  .map((e) => InkWell(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12,
                                                                horizontal: 16),
                                                        child: Text(e),
                                                      ),
                                                      onTap: () async {
                                                        String result =
                                                            "success";
                                                        try {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'posts')
                                                              .doc(data[
                                                                      'postId']
                                                                  .toString())
                                                              .delete();
                                                        } catch (err) {
                                                          result =
                                                              err.toString();
                                                        }
                                                        showSnackBar(
                                                            result, context);
                                                        Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                      }))
                                                  .toList()),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.more_outlined),
                                )
                              : Container(),
                        ],
                      ),

                      // IMAGE SECTION OF THE POST
                      GestureDetector(
                        onDoubleTap: () {
                          FireStoreMethods().likePost(
                            data['postId'].toString(),
                            user.uid,
                            data['likes'],
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                data['postUrl'].toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // LIKE, COMMENT SECTION OF THE POST
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: data['likes'].contains(user.uid)
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                  ),
                            onPressed: () => FireStoreMethods().likePost(
                              data['postId'].toString(),
                              user.uid,
                              data['likes'],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.comment_outlined,
                            ),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                  postId: data['postId'].toString(),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(
                                Icons.send,
                              ),
                              onPressed: () {}),
                          Expanded(
                              child: Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                icon: const Icon(Icons.bookmark_border),
                                onPressed: () {}),
                          ))
                        ],
                      ),
                      //DESCRIPTION AND NUMBER OF COMMENTS
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DefaultTextStyle(
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(fontWeight: FontWeight.w800),
                                  child: Text(
                                    '${data['likes'].length} likes',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  )),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: data['username'].toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ${data['description']}',
                                        style: const TextStyle(
                                        color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  child: Text(
                                    'View all comments',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                ),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CommentsScreen(
                                      postId: data['postId'].toString(),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  DateFormat.yMMMd()
                                      .format(data['datePublished'].toDate()),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                              ),
                            ],
                          ))
                    ]));
              });
        },
      ),
    );
  }
}
