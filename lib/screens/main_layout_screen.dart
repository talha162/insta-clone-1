import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'add_post_screen.dart';
import 'feed_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
// import 'package:instaclone162/models/user.dart' as modeluser;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _page = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    refreshUser();
    //  _auth.signOut();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  refreshUser() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
    print('hello refresh user');
  }

  @override
  Widget build(BuildContext context) {
    // modeluser.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        children: [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          ProfileScreen(uid: _auth.currentUser!.uid)
        ],
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(onTap: navigationTapped, items: [
        BottomNavigationBarItem(
            icon:
                Icon(Icons.home, color: _page == 0 ? Colors.blue : Colors.grey),
            label: '',
            backgroundColor: Colors.blue),
        BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: _page == 1 ? Colors.blue : Colors.grey),
            label: '',
            backgroundColor: Colors.blue),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_circle,
                color: _page == 2 ? Colors.blue : Colors.grey),
            label: '',
            backgroundColor: Colors.blue),
        BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _page == 4 ? Colors.blue : Colors.grey),
            label: '',
            backgroundColor: Colors.blue)
      ]),
    );
  }
}
