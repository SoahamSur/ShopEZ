import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class InventoryPage2 extends StatefulWidget {

  @override
  _InventoryPage2 createState() => _InventoryPage2();
}

class _InventoryPage2 extends State<InventoryPage2> {
  final SupabaseService _supabaseService = SupabaseService(Supabase.instance.client);
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final items = await _supabaseService.fetchItems();
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('negga'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _supabaseService.addItem(
                    'Example Item', 100.69, 'This is an example subtext');
                _fetchItems(); // Refresh the list after adding a new item
              },
              child: Text('Add Item to Supabase'),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true, // Prevent unbounded height error
              physics: NeverScrollableScrollPhysics(), // Prevent scrolling inside ListView
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index]['details'];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text(item['subtext']),
                  trailing: Text('\$${item['price']}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  // Add item to the 'newitems' table
  Future<void> addItem(String name, double price, String subtext) async {
    try {
      final details = {
        'name': name,
        'price': price,
        'subtext': subtext,
      };

      final response = await _client
          .from('newitems')
          .insert({'details': details});

      if (response.error != null) {
        throw response.error!;
      } else {
        print('Item added successfully to newitems!');
      }
    } catch (e) {
      print('Error adding item to newitems: $e');
    }
  }

  // Fetch items from the 'newitems' table
  Future<List<Map<String, dynamic>>> fetchItems() async {
    try {
      final List<dynamic> response = await _client
          .from('newitems')
          .select();

      return response.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error fetching items: $e');
      return [];
    }
  }
}