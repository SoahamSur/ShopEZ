import 'package:flutter/material.dart';
import '../../features/authentication/screens/customer_pages/customer_list.dart';
import '../../features/authentication/screens/inventory_page/inventory_page.dart';
import '../../features/authentication/screens/scan_page/scan_items_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CustomerList()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScanPageTest()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InventoryPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
            color: Color(0xFF232323),
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavBarItem(
                icon: Icons.person,
                label: 'Customer',
                index: 0,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
                backgroundColor: Color(0xFF232323),
                iconColor: Color(0xFF8c8d87),
              ),
              _buildNavBarItem(
                icon: Icons.qr_code_scanner,
                label: 'Scan Items',
                index: 1,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
                backgroundColor: Color(0xff56B253),  // Changed color
                iconColor: Color(0xFF232323),
              ),

              _buildNavBarItem(
                icon: Icons.inventory,
                label: 'Inventory',
                index: 2,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped,
                backgroundColor: Color(0xFF232323),
                iconColor: Color(0xFF8c8d87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem({
    required IconData icon,
    required String label,
    required int index,
    required int selectedIndex,
    required Function(int) onTap,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0), // Margin added here
        padding: const EdgeInsets.symmetric(horizontal: 30), // Optional horizontal padding
        decoration: BoxDecoration(
          color: isSelected ? backgroundColor : backgroundColor.withOpacity(1.0),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(height: 4), // Space between icon and label
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontSize: 10,
                fontFamily: 'lexend',
              ),
            ),
          ],
        ),
      ),
    );
  }
}