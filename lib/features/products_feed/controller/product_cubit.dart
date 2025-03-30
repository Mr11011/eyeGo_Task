import 'package:bloc/bloc.dart';
import 'package:task_eyego/features/products_feed/controller/products_states.dart';
import 'package:task_eyego/features/products_feed/services/product_service.dart';

class ProductCubit extends Cubit<ProductsStates> {
  final ProductService _productService;

  ProductCubit({required ProductService productService})
      : _productService = productService,
        super(ProductsInitialState());

  Future<void> fetchProducts() async {
    emit(ProductsLoadingState());
    try {
      final products = await _productService.fetchProducts();
      emit(ProductsSuccessState(products));
    } catch (e) {
      emit(ProductsErrorState("Failed to fetch products"));
    }
  }
}
