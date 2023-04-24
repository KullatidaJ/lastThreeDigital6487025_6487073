import 'package:flutter/material.dart';
import 'package:national_view/Page/SignIn.dart';
import 'package:national_view/component/SingInButton.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          //(horizontal = แนวนอน)
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Column(
              children: [
      
                //text - 'National View',  
                Text(
                  'National View',
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
      
      
                //text - "Let's go on a trip!!"
                const SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Text(
                    "Let's go on a trip!!",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
      
      
                //Image
                const SizedBox(height: 10),
                Image.network('https://atlas-content-cdn.pixelsquid.com/assets_v2/212/2129219568780973714/jpeg-600/G03.jpg?modifiedAt=1',
                height: 300,
                width: 300,
                ),
      
      
                //SignIn Button
                const SizedBox(height: 10),
                SignInButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInPage(),
                        ));
                  },
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