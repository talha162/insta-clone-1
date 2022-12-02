import 'package:flutter/material.dart';
import 'package:instaclone162/providers/user_provider.dart';
import 'package:instaclone162/screens/login_screen.dart';
import 'package:instaclone162/extras/extra_func.dart';
import 'package:provider/provider.dart';
import 'screens/main_layout_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
    await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(),)
      ],
      child: MaterialApp(
          title: 'Instagram Clone',
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const   MainScreen();
                } else if (snapshot.hasError) {
                  showSnackBar(snapshot.error.toString(), context);
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }
              return const LoginScreen();
            },
          )),
    );
  }
}
