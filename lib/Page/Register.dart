import 'package:flutter/material.dart';
import 'package:national_view/Page/Home.dart';
import 'package:national_view/Page/SignIn.dart';
import 'package:national_view/component/SingUpButton.dart';
import 'package:national_view/component/TextFormField.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  Color _textColor = Colors.grey;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      //create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      //add user detials
      addUserDetails(
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }

  Future addUserDetails(String firsName, String lastName, String email, String password) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firsName,
      'last name': lastName,
      'email': email,
      'password': password,
    });
  }

  bool passwordConfirmed() {
    if (passwordController.text.trim() ==
        confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

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
                  'Register',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //FirstName textformfield
                const SizedBox(height: 20),
                MyTextFormField(
                  controller: firstNameController,
                  hintText: 'Frist Name',
                  obscureText: false,
                ),

                //LestName textformfield
                const SizedBox(height: 20),
                MyTextFormField(
                  controller: lastNameController,
                  hintText: 'Last Name',
                  obscureText: false,
                ),

                //email textformfield
                const SizedBox(height: 20),
                MyTextFormField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                //password textformfield
                const SizedBox(height: 20),
                MyTextFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                //check password textformfield
                const SizedBox(height: 20),
                MyTextFormField(
                  controller: confirmpasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                //SignIn Button
                const SizedBox(height: 30),
                SignUpButton(
                  onTap: () async {
                    //ใช้ if - check ว่า user กรอกข้อมูลครบไหม
                    if (passwordController.text !=
                        confirmpasswordController.text) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: //จะ pop up เป็นกล่องขึ้นมาเตือน
                              const Text(
                                  'Passwords do not match \n Please enter a matching password.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    }
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        confirmpasswordController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: //จะ pop up เป็นกล่องขึ้นมาเตือน
                              const Text('Please fill out all information.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    } else {
                      await signUp(); // เรียกใช้งานฟังก์ชัน signUp()
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()),
                      ); //HomePage() ต้องไปเอาของปอมาเชื่อม
                    }
                  },
                ),

                //text - 'I am  a member! Login now',
                const SizedBox(height: 10),
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
                                builder: (context) => SignInPage(),
                              ));
                        },
                        child: const Text(
                          'I am  a member! Login now',
                          style: TextStyle(color: Colors.grey),    
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//แหล่งที่มา: 
//Flutter Login Page: https://youtu.be/Dh-cTQJgM-Q
//Flutter Register Page: https://youtu.be/idJDAdn_jKk
//Flutter Firebase: https://youtu.be/rWamixHIKmQ