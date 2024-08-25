import 'package:flutter/material.dart';
import 'package:my_login_app/src/common_widgets/fade_animations/fade_in_animations_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common_widgets/nav_bar/nav_bar.dart';
import 'bill_page.dart';
import 'item_data.dart';

class Customer {
  final String name;
  final String surname;
  final String number;
  double due;

  Customer({
    required this.name,
    required this.surname,
    required this.number,
    required this.due,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] as String,
      surname: json['surname'] as String,
      number: json['number'] as String,
      due: json['due'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'number': number,
      'due': due,
    };
  }
}

class CustomerSelect extends StatefulWidget {
  final List<ItemForBill> billItems;
  const CustomerSelect({required this.billItems});

  @override
  _CustomerSelectState createState() => _CustomerSelectState();
}

class _CustomerSelectState extends State<CustomerSelect> {
  List<Customer> customers = [];
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      final List<dynamic> response = await _supabase.from('customerpage').select();

      setState(() {
        customers = response.map((itemData) {
          return Customer(
            name: itemData['details']['name'].toString(),
            surname: itemData['details']['surname'].toString(),
            number: itemData['details']['number'].toString(),
            due: itemData['details']['due'].toDouble(),
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching customers from Supabase: $e');
    }
  }
  Future<void> _updateCustomerDue(Customer customer) async {
    try {
      await _supabase
          .from('customerpage')
          .update({'details': customer.toJson()})
          .eq('details->>name', customer.name)
          .eq('details->>surname', customer.surname);

      _fetchCustomers(); // Refresh the list of customers after updating
    } catch (e) {
      print('Error updating customer due in Supabase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.10,
                color: Colors.black,
                padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.list_alt,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Select Customer',
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
              Container(
                height: MediaQuery.of(context).size.height * 0.81,
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
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 2 cards per row
                                  crossAxisSpacing: 1,
                                  mainAxisSpacing: 1,
                                  childAspectRatio: 1,
                                ),
                                itemCount: customers.length,
                                itemBuilder: (context, index) {
                                  final customer = customers[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // Navigate to a new page with customer details
                                      double subtotal = widget.billItems.fold(0, (sum, item) => sum + item.price);
                                      setState(() {
                                        customer.due += subtotal; // Deduct the payed amount from the due
                                      });
                                      _updateCustomerDue(customer);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlankPage(billItems: widget.billItems),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40.0),
                                      ),
                                      color: Color(0xffF1F1F1),
                                      elevation: 0,
                                      child: Stack(
                                        children: [
                                          const Positioned(
                                            top: 12,
                                            left: 12,
                                            child: CircleAvatar(
                                              backgroundColor: Color(0xff56B253),
                                              radius: 32,
                                              child: Icon(Icons.person, color: Colors.white),
                                            ),
                                          ),
                                          Positioned(
                                            top: 80,
                                            left: 16,
                                            child: Text(
                                              customer.name,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'lexend',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 100,
                                            left: 16,
                                            child: Text(
                                              customer.surname,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 29,
                                                fontFamily: 'lexend',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 8,
                                            right: 16,
                                            child: Text(
                                              'Rs. ${customer.due}',
                                              style: TextStyle(
                                                color:Color(0xff56B253),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'lexend',
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const NavBar(),
        ],
      ),
    );
  }
}

// Define a new page for customer details
