import 'package:flutter/material.dart';
import 'package:my_login_app/src/common_widgets/fade_animations/fade_in_animations_controller.dart';
import '../../../../common_widgets/nav_bar/nav_bar.dart';
import 'item_data.dart';

class BlankPage extends StatelessWidget {
  final List<ItemForBill> billItems;
  const BlankPage({required this.billItems});

  @override
  Widget build(BuildContext context) {
    double subtotal = billItems.fold(0, (sum, item) => sum + item.price);
    print(billItems);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.10,
                color: Colors.black,
                padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Bill',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'lexend',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FadeInAnimation(
                  duration: const Duration(seconds: 1),
                  child: Container(
                    color: Colors.black,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Bill Generated Successfully",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'lexend',
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Image.asset(
                              'assets/images/bill_done.png',
                              height: MediaQuery.of(context).size.height * 0.35,
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                color: Color(0xffBAF0B8),// Background color blue
                                borderRadius: BorderRadius.circular(40), // Optional: rounded corners
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0), // Padding inside the blue container
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: billItems.map((item) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${item.name} ( ${item.count} )',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.grey[800], // Changed text color for contrast
                                                fontFamily: 'lexend',
                                              ),
                                            ),
                                            Text(
                                              'Rs.${item.price}',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Color(0xff56B253), // Changed text color for contrast
                                                fontFamily: 'lexend',
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Text(
                                    'Subtotal : Rs.$subtotal',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      color: Color(0xff56B253),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'lexend',
                                    ),
                                  ),
                                ),
                              ],
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