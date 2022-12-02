import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaclone162/screens/signup_screen.dart';
import 'package:instaclone162/extras/extra_func.dart';
import 'package:instaclone162/widgets/text_field.dart';
import 'package:instaclone162/resources/auth_methods.dart';

import 'main_layout_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String result = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    setState(() {
      _isLoading = false;
    });
    if (result == "Login Success") {
      navigateToWithNoBack(
        context: context,
        new_route: MainScreen(),
      );
    } else {
      showSnackBar(result, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 26),
          child: Column(children: [
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Flexible(
              flex: 7,
              child: Column(
                children: [
                  Image(
                    image: AssetImage('lib/pics/applogo.jpeg'),
                    height: 80,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextInputField(
                      hintText: 'Enter Email',
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                      isPassword: false),
                  SizedBox(
                    height: 10,
                  ),
                  TextInputField(
                      hintText: 'Enter Password',
                      textInputType: TextInputType.visiblePassword,
                      textEditingController: _passwordController,
                      isPassword: true),
                  SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    child: _isLoading
                        ? CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.white,
                          )
                        : Text('Login'),
                    onPressed: loginUser,
                    color: Colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 110, vertical: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      InkWell(
                        onTap: () {
                          navigateToWithBack(
                              context: context, new_route: SignupScreen());
                        },
                        child: Text(" Signup",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              child: Container(),
              flex: 1,
            ),
          ]),
        )));
  }
}
