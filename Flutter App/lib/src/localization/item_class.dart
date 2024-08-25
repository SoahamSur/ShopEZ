import 'package:flutter/material.dart';
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