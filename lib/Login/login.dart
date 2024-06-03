import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaint_management/Homescreen.dart';
import 'package:complaint_management/Login/sign-up.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController userIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  double? height, width;

  @override
  void dispose() {
    userIDController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: height! * .5,
                  decoration: const BoxDecoration(
                      // color: Colors.blue,
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue,
                            Color.fromARGB(255, 220, 137, 234)
                          ]),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: const CircleAvatar(
                    child: Icon(
                      Icons.home,
                      color: Colors.blue,
                      size: 40,
                    ),
                    radius: 50,
                    backgroundColor: Colors.white,
                  ),
                ),
                Container(
                  height: height! * .5,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 120,
              child: Card(
                elevation: 10,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Center(
                            child: Text(
                          'LOGIN',
                          style: TextStyle(letterSpacing: 2, fontSize: 20),
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: userIDController,
                          decoration: const InputDecoration(
                              labelText: 'Username',
                              hintText: 'Enter you username',
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.purple))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your UserID';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter you password',
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.purple))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                ),
                height: 50,
                width: 200,
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login(userIDController.text, passwordController.text,
                            context);
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              // child: ElevatedButton(
              //   onPressed: () {},
              //   child: const Text('Login'),
              // ),
            ),
            Positioned(
              bottom: 45,
              left: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'FORGOT PASSWORD?',
                      )),
                  SizedBox(
                    width: 110,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()));
                      },
                      child: Text(
                        'SIGN UP',
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void storeLoginData(bool isLogin, String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userID');
    prefs.setBool('isLogin', isLogin);
    prefs.setString('userID', userID);
  }

  Future<void> login(
      String userID, String password, BuildContext context) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Usres')
          .doc(userID)
          .get();
      if (userDoc.exists) {
        final storedPassword = userDoc.data()!['Password'];
        print(storedPassword);
        if (password == storedPassword) {
          storeLoginData(true, userIDController.text);
          SnackBar snackBar = SnackBar(
              backgroundColor: Colors.green,
              content: Center(
                child: Text('Login successful'),
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false);
        } else {
          SnackBar snackBar = SnackBar(
              backgroundColor: Colors.red,
              content: Center(
                child: Text('Incorrect Password'),
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        SnackBar snackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text('User does not exist'),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
