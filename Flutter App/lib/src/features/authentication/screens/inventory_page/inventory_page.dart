import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Item {
  String id;
  String name;
  String subText;
  double? price;
  bool isAdded;
  List<Variant> variants;

  Item({
    required this.id,
    required this.name,
    required this.subText,
    this.price,
    this.isAdded = false,
    this.variants = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subText': subText,
      'price': price,
      if (variants.isNotEmpty)
        'variants': variants.map((variant) => variant.toJson()).toList(),
    };
  }
}

class Variant {
  double weight;
  double price;

  Variant({this.weight = 0.0, this.price = 0.0});

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'price': price,
    };
  }

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      weight: (json['weight'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
    );
  }
}

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  SupabaseClient get supabase => Supabase.instance.client;

  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    _fetchItemsFromSupabase();
  }

  Future<void> _fetchItemsFromSupabase() async {
    try {
      final response = await supabase.from('newitems').select();

      if (response != null) {
        setState(() {
          items = (response as List<dynamic>).map((itemData) {
            return Item(
              id: itemData['id'].toString(),
              name: itemData['details']['name'].toString(),
              subText: itemData['details']['subText'].toString(),
              price: itemData['details']['price'] != null
                  ? double.tryParse(itemData['details']['price'].toString())
                  : null,
              variants: itemData['details']['variants'] != null
                  ? List<Map<String, dynamic>>.from(itemData['details']['variants'])
                  .map((variantData) => Variant.fromJson(variantData))
                  .toList()
                  : [],
            );
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching items from Supabase: $e');
    }
  }

  void _addItem() async {
    final newItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailPage(onSave: (item) {}),
      ),
    );

    if (newItem != null) {
      final existingItem = items.firstWhere(
            (item) => item.name.toLowerCase() == newItem.name.toLowerCase(),
        orElse: () => Item(
          id: '',
          name: '',
          subText: '',
        ),
      );

      if (existingItem.id.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Duplicate Item'),
              content: const Text('This item has already been added. Try editing the existing item.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          items.add(newItem);
        });
        await _addItemToSupabase(newItem);
      }
    }
  }

  Future<void> _addItemToSupabase(Item item) async {
    try {
      await supabase.from('newitems').insert({'details': item.toJson()});
    } catch (e) {
      print('Error adding item to Supabase: $e');
    }
  }

  Future<void> _updateItemInSupabase(Item item) async {
    try {
      await supabase.from('newitems').update({'details': item.toJson()}).eq('id', item.id);
    } catch (e) {
      print('Error updating item in Supabase: $e');
    }
  }

  Future<void> deleteItem(Item item) async {
    try {
      await supabase.from('newitems').delete().eq('id', item.id);
      print('Item deleted from Supabase');
    } catch (e) {
      print('Error deleting item from Supabase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,), // You can change this to any icon
          onPressed: () {
            // Custom behavior for back button
            Navigator.pop(context);
          },
        ),
        title: const Text('Inventory', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 34),
            onPressed: _addItem,
          ),
          const SizedBox(width: 40),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ...items.map((item) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xffF1F1F1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 20, // Set your desired font size here
                        color: Colors.black, // Set your desired color here
                      ),
                    ),
                    subtitle: Text(
                      item.subText,
                      style: const TextStyle(
                        fontSize: 16, // Set your desired font size here
                        color: Colors.grey, // Set your desired color here
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Color(0xff56B253)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailPage(
                                  item: item,
                                  onSave: (updatedItem) async {
                                    await _updateItemInSupabase(updatedItem);
                                  },
                                ),
                              ),
                            ).then((updatedItem) {
                              if (updatedItem != null) {
                                setState(() {
                                  final index = items.indexWhere((i) => i.id == item.id);
                                  if (index != -1) {
                                    items[index] = updatedItem;
                                  }
                                });
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Color(0xff56B253)),
                          onPressed: () async {
                            setState(() {
                              items.remove(item);
                            });
                            await deleteItem(item);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemDetailPage extends StatefulWidget {
  final Item? item;
  final Function(Item) onSave;

  ItemDetailPage({this.item, required this.onSave});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Variant> variants = [];
  bool _hasPrice = false;
  late String _name;
  late String _subText;
  late double? _price;

  List<String> productNames = [];
  String? selectedProductName;
  final TextEditingController _productNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _name = widget.item!.name;
      _subText = widget.item!.subText;
      _price = widget.item!.price;
      variants.addAll(widget.item!.variants);
      _hasPrice = _price != null;
      _productNameController.text = _name;
    } else {
      _name = '';
      _subText = '';
      _price = null;
    }
    _fetchProductNames();
  }

  Future<void> _fetchProductNames() async {
    try {
      final response = await Supabase.instance.client
          .from('newproducts')
          .select('products');

      if (response != null) {
        setState(() {
          productNames = List<String>.from(
              (response as List<dynamic>).map((product) => product['products'].toString()));
        });
      }
    } catch (e) {
      print('Error fetching product names: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add/Modify Item', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Search Product Name',
                ),
                onChanged: (value) {
                  setState(() {
                    selectedProductName = value;
                    _name = value;
                  });
                },
              ),
              if (productNames.isNotEmpty && selectedProductName != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: productNames.length,
                    itemBuilder: (context, index) {
                      final productName = productNames[index];
                      if (productName.toLowerCase().contains(
                          selectedProductName!.toLowerCase())) {
                        return ListTile(
                          title: Text(productName),
                          onTap: () {
                            setState(() {
                              _name = productName;
                              selectedProductName = null;
                              _productNameController.text = _name;
                            });
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              TextFormField(
                initialValue: _subText,
                decoration: const InputDecoration(labelText: 'Subtext'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subtext';
                  }
                  return null;
                },
                onSaved: (value) {
                  _subText = value!;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Has Price?'),
                  Switch(
                    value: _hasPrice,
                    onChanged: (value) {
                      setState(() {
                        _hasPrice = value;
                        if (!_hasPrice) {
                          _price = null;
                        } else {
                          variants.clear();
                        }
                      });
                    },
                  ),
                ],
              ),
              if (_hasPrice)
                TextFormField(
                  initialValue: _price != null ? _price.toString() : '',
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_hasPrice && (value == null || value.isEmpty)) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _price = value != null && value.isNotEmpty
                        ? double.tryParse(value)
                        : null;
                  },
                ),
              if (!_hasPrice) ...[
                const SizedBox(height: 20),
                const Text('Variants'),
                const SizedBox(height: 10),
                ...variants.map((variant) {
                  return ListTile(
                    title: Text('Weight: ${variant.weight}, Price: ${variant.price}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          variants.remove(variant);
                        });
                      },
                    ),
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: () async {
                    final newVariant = await Navigator.push<Variant>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VariantDetailPage(),
                      ),
                    );

                    if (newVariant != null) {
                      setState(() {
                        variants.add(newVariant);
                      });
                    }
                  },
                  child: const Text('Add Variant'),
                ),
              ],
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final newItem = Item(
                          id: widget.item?.id ?? DateTime.now().toString(),
                          name: _name,
                          subText: _subText,
                          price: _price,
                          variants: variants,
                        );
                        widget.onSave(newItem);
                        Navigator.pop(context, newItem);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VariantDetailPage extends StatefulWidget {
  @override
  _VariantDetailPageState createState() => _VariantDetailPageState();
}

class _VariantDetailPageState extends State<VariantDetailPage> {
  final _formKey = GlobalKey<FormState>();
  double _weight = 0.0;
  double _price = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Variant Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a weight';
                  }
                  return null;
                },
                onSaved: (value) {
                  _weight = double.tryParse(value!) ?? 0.0;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.tryParse(value!) ?? 0.0;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(
                      context,
                      Variant(weight: _weight, price: _price),
                    );
                  }
                },
                child: const Text('Save Variant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}