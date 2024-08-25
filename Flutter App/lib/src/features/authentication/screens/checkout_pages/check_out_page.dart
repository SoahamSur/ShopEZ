import 'package:flutter/material.dart';
import 'package:my_login_app/src/common_widgets/fade_animations/fade_in_animations_controller.dart';

import '../../../../common_widgets/nav_bar/nav_bar.dart';
import '../../../../localization/item_class.dart';
// import 'bill_page.dart';
// import 'checkoutdata.dart';
import 'customer_select.dart';
import 'item_data.dart';



class CheckOutPage extends StatefulWidget {
  Map<String, Item> items;
  Map<String, int> checkoutdata;
  CheckOutPage({super.key, required this.items,required this.checkoutdata});

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  // CheckoutData checkoutData = CheckoutData();

  // Initialize the counters and keys using checkoutInfo data
  late List<int> counters;
  late List<ItemForBill> billItems;
  late Map<String, Item> newItems;
  late List<Map<String, double>> totalCounters;
  late List<String> currentKeys;
  late List<String> itemNames;
  late List<String> itemSubtexts=[];
  late List<Item> filteredItems;
  double subtotal = 0;

  @override
  void initState() {
    super.initState();
    filterItems();
    enterItems();

    // Initialize counters and currentKeys based on newItems
    counters = newItems.keys.map((key) => widget.checkoutdata[key] ?? 0).toList();
    totalCounters = [];
    currentKeys = [];
    for (var i = 0; i < filteredItems.length; i++) {
      totalCounters.add(addVariant(filteredItems[i]));
      currentKeys.add(addVariant(filteredItems[i]).entries.first.key.toString());
      print(addVariant(filteredItems[i]).entries.first);
    }
    // Initialize itemNames from newItems
    itemNames = newItems.keys.toList();
    for(var entry in newItems.entries ){
      itemSubtexts.add(entry.value.subText);
    }

    subtotal = calculateSubTotal();
  }

  void filterItems() {
    newItems = {}; // Initialize the newItems map

    for (var entry in widget.checkoutdata.entries) {
      if (widget.items.containsKey(entry.key)) {
        newItems[entry.key] = widget.items[entry.key]!; // Add the item to newItems
      }
    }
  }

  void enterItems() {
    filteredItems = [];

    for (var entry in newItems.entries) {
      filteredItems.add(entry.value);
    }
    print(filteredItems);
  }

  Map<String, double> addVariant(Item item) {
    Map<String, double> temp = {};
    if (item.price == null) {
      for (var entry in item.variants) {
        temp[entry.weight.toString()] = entry.price;
      }
    } else {
      temp[""] = item.price!;
    }
    return temp;
  }
  List<double> calculateCardTotals() {
    List<double> cardTotals = [];
    for (int i = 0; i < totalCounters.length; i++) {
      cardTotals.add(counters[i] * totalCounters[i][currentKeys[i]]!);
    }
    return cardTotals;
  }

  double calculateSubTotal() {
    double subtotal = 0;
    for (int i = 0; i < totalCounters.length; i++) {
      subtotal += counters[i] * totalCounters[i][currentKeys[i]]!;
    }
    return subtotal;
  }

  void incrementCounter(int index) {
    setState(() {
      counters[index]++;
      subtotal = calculateSubTotal();
    });
  }

  void decrementCounter(int index) {
    setState(() {
      if (counters[index] > 1) {
        counters[index]--;
        subtotal = calculateSubTotal();
      }
    });
  }

  void incrementTotalCounter(int index) {
    setState(() {
      final currentKey = currentKeys[index];
      final keys = totalCounters[index].keys.toList();
      final currentIndex = keys.indexOf(currentKey);
      final nextIndex = (currentIndex + 1) % keys.length;
      currentKeys[index] = keys[nextIndex];
      subtotal = calculateSubTotal();
    });
  }

  void decrementTotalCounter(int index) {
    setState(() {
      final currentKey = currentKeys[index];
      final keys = totalCounters[index].keys.toList();
      final currentIndex = keys.indexOf(currentKey);
      final prevIndex = (currentIndex - 1 + keys.length) % keys.length;
      currentKeys[index] = keys[prevIndex];
      subtotal = calculateSubTotal();
    });
  }

  void deleteCard(int index) {
    // Ensure the index is within the bounds of the lists
    if (index < 0 || index >= newItems.length) return;

    setState(() {
      // Adjust the subtotal by removing the selected item's contribution
      subtotal -= counters[index] * totalCounters[index][currentKeys[index]]!;

      // Get the key associated with the current index in the map
      String keyToRemove = currentKeys[index];

      // Remove the item at the specified index from all related lists
      counters.removeAt(index);
      totalCounters.removeAt(index);
      currentKeys.removeAt(index);
      itemNames.removeAt(index);
      filteredItems.removeAt(index);

      // Remove the key-value pair from the newItems map
      newItems.remove(keyToRemove);

      // If necessary, you might want to recalculate the subtotal
      subtotal = calculateSubTotal();
    });
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
                padding: const EdgeInsets.only(left: 20.0, top: 30.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.directions_walk,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Checkout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'lexend',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 100),
                    Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SUB-TOTAL',
                            style: TextStyle(
                              color: Color(0xff56B253),
                              fontSize: 13.0,
                              fontFamily: 'lexend',
                            ),
                          ),
                          const SizedBox(height: 0.0),
                          Text(
                            'Rs. ${subtotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Color(0xff56B253),
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'lexend',
                            ),
                          ),
                        ],
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
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(newItems.length, (index) {
                              final currentKey = currentKeys[index];
                              final currentValue = totalCounters[index][currentKey]!;
                              final itemCountVal = counters[index];
                              final itemName = itemNames[index];
                              final itemSubtext = itemSubtexts[index];
                              return Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.98,
                                    height: MediaQuery.of(context).size.height * 0.2125,
                                    margin: const EdgeInsets.only(bottom: 12.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF1F1F1),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.26,
                                                height: MediaQuery.of(context).size.height * 0.120,
                                                decoration: BoxDecoration(
                                                  color: Color(0xff56B253),
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                child: const Icon(
                                                  Icons.image,
                                                  color: Color(0xffF1F1F1),
                                                  size: 60,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    itemName, // Display the item name dynamically
                                                    style: const TextStyle(
                                                      fontSize: 22.0,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'lexend',
                                                    ),
                                                  ),
                                                  Text(
                                                    itemSubtext,
                                                    style:const TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontFamily: 'lexend',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 25),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffF1F1F1),
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                        width: 38.0,
                                                        height: 38.0,
                                                        child: Center(
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Icons.remove,
                                                              color: Color(0xff56B253),
                                                            ),
                                                            onPressed: () => decrementCounter(index),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffF1F1F1),
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                        width: 35,
                                                        height: 35,
                                                        child: Center(
                                                          child: Text(
                                                            '${counters[index]}',
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(0xff56B253),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffF1F1F1),
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                        width: 38.0,
                                                        height: 38.0,
                                                        child: Center(
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Icons.add,
                                                              color: Color(0xff56B253),
                                                            ),
                                                            onPressed: () => incrementCounter(index),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffBAF0B8),
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
                                                    width: 38.0,
                                                    height: 38.0,
                                                    child: Center(
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Color(0xff56B253),
                                                        ),
                                                        onPressed: () => decrementTotalCounter(index),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffF1F1F1),
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                        width: 100,
                                                        height: 16,
                                                        child: Center(
                                                          child: Text(
                                                            '${currentKeys[index]}g',
                                                            style: TextStyle(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(0xff56B253),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Color(0xffF1F1F1),
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                        width: 100,
                                                        height: 25,
                                                        child: Center(
                                                          child: Text(
                                                            'Rs. ${currentValue}',
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(0xff56B253),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffBAF0B8),
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
                                                    width: 38.0,
                                                    height: 38.0,
                                                    child: Center(
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.arrow_drop_up,
                                                          color: Color(0xff56B253),
                                                        ),
                                                        onPressed: () => incrementTotalCounter(index),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 15.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    const Text(
                                                      'TOTAL',
                                                      style: TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xffF1F1F1),
                                                        fontFamily: 'lexend',
                                                      ),
                                                    ),
                                                    Text(
                                                      'Rs. ${(itemCountVal * currentValue).toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xff56B253),
                                                        fontFamily: 'lexend',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 5.0,
                                    right: 5.0,
                                    child: InkWell(
                                      onTap: () => {
                                        // deleteCard(index),
                                      },
                                      child: Container(
                                        width: 25.0,
                                        height: 25.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xffF1F1F1),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Color(0xffF1F1F1),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 80 + kBottomNavigationBarHeight, // Positioned above the navbar
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                },
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Color(0xff56B253),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child:Center(
                    child: IconButton(
                      onPressed: (){
                        List<double> cardTotals = calculateCardTotals();
                        print(itemNames);
                        billItems=[];
                        for(var i=0 ; i<counters.length; i++){
                          billItems.add(
                            ItemForBill(name: itemNames[i], count: counters[i], price: cardTotals[i]),
                          );
                        }
                        print(billItems);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CustomerSelect(billItems:billItems)),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward,
                        color: Colors.white,
                        size: 30.0,),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const NavBar(),
        ],
      ),
    );
  }
}
