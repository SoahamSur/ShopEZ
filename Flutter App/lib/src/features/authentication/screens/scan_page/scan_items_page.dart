import 'package:flutter/material.dart';
import 'package:my_login_app/src/common_widgets/fade_animations/fade_in_animations_controller.dart';
import 'package:my_login_app/src/features/authentication/screens/scan_page/camera_setup_page.dart';

import '../../../../common_widgets/nav_bar/nav_bar.dart';

class ScanPageTest extends StatefulWidget {
  const ScanPageTest({super.key});

  @override
  State<ScanPageTest> createState() => _ScanPageTestState();
}

class _ScanPageTestState extends State<ScanPageTest> {
  // int imgCount=0;

  // void updateVariable(int newValue) {
  //   setState(() {
  //     imgCount = newValue;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // 10% Black area at the top with an icon and text
              Container(
                height: MediaQuery.of(context).size.height * 0.10,
                color: Colors.black,
                padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                    SizedBox(width:MediaQuery.of(context).size.width * 0.02,),
                    const Text(
                      'Scan Items',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'lexend',
                      ),
                    ),
                  ],
                ),
              ),
              // 90% White rounded area with a single large card aligned to the top
              Expanded(
                child: FadeInAnimation(
                  duration: const Duration(seconds: 1),
                  child: Container(
                    color: Colors.black,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25,0, 25, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: MediaQuery.of(context).size.height * 0.82,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: const CameraSetupPage(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Floating navigation bar
          const NavBar(),
        ],
      ),
    );
  }
}
