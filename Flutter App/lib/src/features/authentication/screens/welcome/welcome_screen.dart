import 'package:flutter/material.dart';
import 'package:my_login_app/src/common_widgets/fade_animations/fade_in_animations_controller.dart';
import 'package:my_login_app/src/features/authentication/screens/welcome/sign_in.dart';
import '../../../../common_widgets/fade_animations/page_route.dart';
import '../../../../constants/image_string.dart';
import '../customer_pages/customer_list.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                // height: screenHeight * 0.3,
                color: Colors.black,
                child: Center(
                  child: Image.asset(
                    tLogoImg,
                    height: MediaQuery.of(context).size.height * 0.32,
                    width: MediaQuery.of(context).size.height * 0.32,
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(0.0),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'lexend',
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignInPage()),
                              );
                            },
                            child: const Text(
                              "Already have an account? Sign in",
                              style: TextStyle(
                                color: Color(0xff56B253),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.sizeOf(context).height * 0.03,),
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
                        SizedBox(height: MediaQuery.sizeOf(context).height * 0.03,),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Username',
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
                        SizedBox(height: MediaQuery.sizeOf(context).height * 0.03,),
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
                          child: TextButton(
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
                              backgroundColor: Color(0xff56B253),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 80,
                                vertical: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'lexend',
                                fontSize: 25.0,
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
                              child: TextButton.icon(
                                onPressed: () {
                                  // Sign in with Google
                                },
                                icon: Image(image: AssetImage('assets/logo/google.png'), height: MediaQuery.sizeOf(context).width * 0.065,),
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
                                    fontSize: 24.0,
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
          ],
        ),
      ),
    );
  }
}
