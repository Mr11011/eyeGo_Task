import 'package:task_eyego/features/products_feed/model/rating_model.dart';

class ProductsModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingModel rating;

  ProductsModel(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.category,
      required this.rating,
      required this.image});

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price']).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: RatingModel.fromJson(json['rating'] as Map<String, dynamic>),
    );
  }
}
