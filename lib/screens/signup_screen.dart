import 'package:flutter/material.dart';
import 'package:instaclone162/resources/auth_methods.dart';
import 'package:instaclone162/screens/login_screen.dart';
import 'package:instaclone162/extras/extra_func.dart';
import '../widgets/text_field.dart';
import 'package:flutter/cupertino.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String result = await AuthMethods().signUpUser(
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text);
    setState(() {
      _isLoading = false;
    });
    
    showSnackBar(result, context);

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
              flex: 1,
            ),
            Flexible(
              flex: 7,
              child: Column(
                children: [
                  Image(image: AssetImage('lib/pics/applogo.jpeg'),height: 80),
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
                      hintText: 'Enter username',
                      textInputType: TextInputType.text,
                      textEditingController: _usernameController,
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
                        : Text('Signup'),
                    onPressed: signUpUser,
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
                      Text("Already have an account?"),
                      InkWell(
                        onTap: () {
                          navigateToWithBack(
                              context: context, new_route: LoginScreen());
                        },
                        child: Text(" Login",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ]),
        )));
  }
}
