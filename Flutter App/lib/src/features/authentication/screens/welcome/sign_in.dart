import 'package:flutter/material.dart';
import 'package:my_login_app/src/common_widgets/fade_animations/fade_in_animations_controller.dart';
import 'package:my_login_app/src/features/authentication/screens/welcome/welcome_screen.dart';
import '../../../../common_widgets/fade_animations/page_route.dart';
import '../customer_pages/customer_list.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FadeInAnimation(
        duration: const Duration(seconds: 1),
        child: Column(
          children: [
            FadeInAnimation(
              duration: const Duration(seconds: 2),
              child: Container(
                height: screenHeight * 0.3,
                color: Colors.black,
                child: const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://www.thedigitalfix.com/wp-content/sites/thedigitalfix/2023/02/giancarlo-esposito-550x309.jpg'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FadeInAnimation(
                duration: const Duration(seconds: 3),
                child: Container(
                  color: Colors.black,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(

                            children: [
                              Center(
                                child: IconButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginPage()),
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_back,
                                    color: Colors.black,
                                    size: 35.0,),
                                ),
                              ),
                              const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontFamily: 'lexend',
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 35),
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 22.0,
                                fontFamily: 'lexend',
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 35),
                          const TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 22.0,
                                fontFamily: 'lexend',
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 35),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  FadeRoute(
                                    page: const CustomerList(),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[400],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 90,
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                'Login In',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'lexend',
                                  fontSize: 28.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Divider(
                                      height: 60.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        'or',
                                        style: TextStyle(
                                          fontFamily: 'lexend',
                                          fontSize: 18.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Divider(
                                      height: 60.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Sign in with Google
                                  },
                                  icon: const Image(image: AssetImage('assets/logo/google_logo.png'), width: 55),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  label: const Text(
                                    'Continue With Google',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'lexend',
                                      fontSize: 27.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
