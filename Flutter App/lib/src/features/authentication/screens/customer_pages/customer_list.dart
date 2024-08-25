import 'package:flutter/material.dart';
import 'package:my_login_app/src/common_widgets/fade_animations/fade_in_animations_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase package
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

import '../../../../common_widgets/nav_bar/nav_bar.dart';

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

  // Create a method to parse JSON data into a Customer object
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] as String,
      surname: json['surname'] as String,
      number: json['number'] as String,
      due: json['due'] as double,
    );
  }

  // Create a method to convert a Customer object into JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'number' : number,
      'due': due,
    };
  }
}

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List<Customer> customers = [];
  SupabaseClient get _supabase => Supabase.instance.client; // List of Customer objects

  @override
  void initState() {
    super.initState();
    _fetchCustomers(); // Fetch customers from Supabase when the page initializes
  }

  // Function to fetch customer data from Supabase
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

  // Function to insert a new customer into Supabase
  Future<void> _addCustomer(Customer customer) async {
    try {
      await _supabase.from('customerpage').insert({'details': customer.toJson()}); // Insert new customer data into the 'customerpage' table

      _fetchCustomers(); // Refresh the list of customers after inserting
    } catch (e) {
      print('Error adding customer to Supabase: $e');
    }
  }

  // Function to update a customer's due amount in Supabase
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

  // Method to show a dialog for updating a customer's due amount
  void _showUpdateDueDialog(Customer customer) {
    String payedAmountString = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Update Due for ${customer.name} ${customer.surname}',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'lexend',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Current Due: Rs. ${customer.due}',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'lexend',
                  color: Color(0xff56B253),
                ),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Payed Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  payedAmountString = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xff56B253),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final double payedAmount = double.tryParse(payedAmountString) ?? 0.0;
                setState(() {
                  customer.due -= payedAmount; // Deduct the payed amount from the due
                });
                _updateCustomerDue(customer); // Update the due amount in Supabase
                Navigator.of(context).pop();
              },
              child: const Text(
                'Update',
                style: TextStyle(
                  color: Color(0xff56B253),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to show the dialog for adding a new customer
  void _showAddCustomerDialog() {
    String name = '';
    String surname = '';
    String number = '';
    String dueString = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add New Customer',
            style: TextStyle(
              fontFamily: 'lexend',
              fontSize: 23,
              color: Color(0xff56B253),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Surname'),
                onChanged: (value) {
                  surname = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Number'),
                onChanged: (value) {
                  number = "+91$value";
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Due Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  dueString = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final double due = double.tryParse(dueString) ?? 0.0;
                final newCustomer = Customer(name: name, surname: surname,number: number, due: due);
                _addCustomer(newCustomer); // Add the new customer to Supabase
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Function to send SMS
  Future<void> _sendSms(Customer customer) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: customer.number,
      queryParameters: {
        'body': 'Hey ${customer.name} ${customer.surname}, You Currently owe Rs. ${customer.due} on your E-Khata, pay here: <linktoUPIid>'
      },
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not send SMS';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.list_alt,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    const Text(
                      'Customer List',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'lexend',
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.40,),
                    IconButton(
                      icon: const Icon(Icons.add_circle, size: 38, color: Color(0xff56B253),),
                      onPressed: _showAddCustomerDialog,
                    ),
                  ],
                ),
              ),
              // 90% White rounded area with scrollable red cards
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
                                itemCount: customers.length, // Number of customers
                                itemBuilder: (context, index) {
                                  final customer = customers[index];
                                  return GestureDetector(
                                    onTap: () {
                                      _showUpdateDueDialog(customer); // Show the update dialog on tap
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
                                            top: 10,
                                            left: 10,
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
                                                color: Color(0xff56B253),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'lexend',
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 12,
                                            right: 12,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.notifications,
                                                color: Color(0xff56B253), // Green color
                                                size: 30,
                                              ),
                                              onPressed: () {_sendSms(customer);}, // Trigger SMS sending function
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