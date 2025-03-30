import 'package:bloc/bloc.dart';
import 'package:task_eyego/features/products_feed/controller/products_states.dart';
import 'package:task_eyego/features/products_feed/model/products_model.dart';
import 'package:task_eyego/features/products_feed/services/product_service.dart';

class ProductCubit extends Cubit<ProductsStates> {
  final ProductService _productService;
  List<ProductsModel> allProducts = []; // Store the full list

  ProductCubit({required ProductService productService})
      : _productService = productService,
        super(ProductsInitialState());

  Future<void> fetchProducts() async {
    emit(ProductsLoadingState());
    try {
      allProducts = await _productService.fetchProducts();

      emit(ProductsSuccessState(allProducts));
    } catch (e) {
      emit(ProductsErrorState("Failed to fetch products"));
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      emit(ProductsSuccessState(allProducts));
    } else {
      final searchedProduct = allProducts
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(ProductsSuccessState(searchedProduct));
    }
  }

  void filterProducts(
      {double? minPrice,
      double? maxPrice,
      double? minRating,
      String? category}) {
    List<ProductsModel> filteredProducts = allProducts;

    if (category != null && category.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) => product.category == category)
          .toList();
    }

    if (minPrice != null) {
      filteredProducts = filteredProducts
          .where((product) => product.price >= minPrice)
          .toList();
    }

    if (maxPrice != null) {
      filteredProducts = filteredProducts
          .where((product) => product.price <= maxPrice)
          .toList();
    }

    if (minRating != null) {
      filteredProducts = filteredProducts
          .where((product) => product.rating.rate >= minRating)
          .toList();
    }

    emit(ProductsSuccessState(filteredProducts));
  }
}
