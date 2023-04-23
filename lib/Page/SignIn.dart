import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:national_view/Page/Home.dart'; //ต้องไปเอาของปอมาเชื่อม
import 'package:national_view/Page/Register.dart';
import 'package:national_view/component/SingInButton.dart';
import 'package:national_view/component/TextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  Color _textColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    // เรียกใช้ Firebase.initializeApp()
    Firebase.initializeApp();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                //text - 'Sign In'
                Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //username textformfield
                const SizedBox(height: 25),
                MyTextFormField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                //password textformfield
                const SizedBox(height: 25),
                MyTextFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                //Don't have an account?
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            //ใช้เมธอด setState เพื่อเปลี่ยนค่า _textColor เมื่อ Text ถูกเลือก
                            _textColor = Colors
                                .blue; //ใช้ค่า _textColor ในการกำหนดสีของ Text เมือกถูกเลือก
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ));
                        },
                        child: Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: _textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //SignIn Button
                const SizedBox(height: 10),
                SignInButton(
                  onTap: () async {
                    //Authen user ด้วย Firebase Authentication
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: usernameController.text,
                        password: passwordController.text,
                      );

                      // ถ้า login สำเร็จ จะไปหน้า HomePage
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        setState(() {
                          errorMessage = 'User not found';
                        });
                      } else if (e.code == 'wrong-password') {
                        setState(() {
                          errorMessage =
                              'Wrong password provided for this user';
                        });
                      }

                      //Show error message ถ้า login ไม่ผ่าน
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content: Text(errorMessage!),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  )
                                ],
                              )
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
