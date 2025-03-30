import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_eyego/features/products_feed/model/products_model.dart';

abstract class ProductsStates {}

class ProductsInitialState extends ProductsStates {}

class ProductsLoadingState extends ProductsStates {}

class ProductsSuccessState extends ProductsStates {
  final List<ProductsModel> products;

  ProductsSuccessState(this.products);
}

class ProductsErrorState extends ProductsStates {
  final String error;

  ProductsErrorState(this.error);
}
