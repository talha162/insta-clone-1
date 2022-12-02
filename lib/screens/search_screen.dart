import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone162/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool showUserOrNot = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(labelText: 'Search user'),
            onFieldSubmitted: (String _) {
              setState(() {
                showUserOrNot = true;
              });
            },
          ),
        ),
      ),
      body: showUserOrNot
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                // String photo =
                        // (snapshot.data! as dynamic).docs[index]['photoUrl'];
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        // leading: CircleAvatar(
                        //   backgroundImage: NetworkImage(
                        //     photo,
                        //   ),
                        //   radius: 16,
                        // ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 1.2,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap =
                        (snapshot.data! as dynamic).docs[index];

                    return Container(
                      child: Image(
                        image: NetworkImage(snap['postUrl']),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
