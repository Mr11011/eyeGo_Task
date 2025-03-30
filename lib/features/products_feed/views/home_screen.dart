import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_eyego/features/auth/cubit/auth_cubit.dart';
import 'package:task_eyego/features/auth/cubit/auth_states.dart';
import 'package:task_eyego/features/products_feed/controller/product_cubit.dart';
import 'package:task_eyego/features/products_feed/services/product_service.dart';
import '../../auth/views/sign_in_screen.dart';
import '../controller/products_states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory;
  double minPrice = 0;
  double maxPrice = 500; // Adjust as needed
  double minRating = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductCubit(productService: ProductService())..fetchProducts(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, authState) {
          if (authState is AuthSignOutState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          }
        },
        builder: (context, authState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Products'),
              actions: [
                IconButton(
                  onPressed: () => context.read<AuthCubit>().signOut(),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: BlocConsumer<ProductCubit, ProductsStates>(
              listener: (context, productState) {
                if (productState is ProductsErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${productState.error}')),
                  );
                }
              },
              builder: (context, productState) {
                if (productState is ProductsLoadingState) {
                  return _buildShimmerEffect();
                } else if (productState is ProductsSuccessState) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            // Search Bar
                            SearchBar(
                              hintText: 'Search products...',
                              leading: Icon(Icons.search),
                              onChanged: (query) {
                                context
                                    .read<ProductCubit>()
                                    .searchProducts(query);
                              },
                              onSubmitted: (query) {
                                context
                                    .read<ProductCubit>()
                                    .searchProducts(query);
                              },
                            ),

                            // Category Filter
                            DropdownButton<String>(
                              value: selectedCategory,
                              hint: Text("Select Category"),
                              isExpanded: false,
                              items: [
                                'All',
                                'electronics',
                                'jewelery',
                                'men\'s clothing',
                                'women\'s clothing'
                              ].map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory =
                                      value == "All" ? null : value;
                                });
                                context.read<ProductCubit>().filterProducts(
                                      category: selectedCategory,
                                      minPrice: minPrice,
                                      maxPrice: maxPrice,
                                      minRating: minRating,
                                    );
                              },
                            ),
                            const SizedBox(height: 5),

                            // Price and rate Filter
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Price Range: \$${minPrice.toInt()} - \$${maxPrice.toInt()}"),
                                RangeSlider(
                                  activeColor: Colors.blue,
                                  inactiveColor: Colors.grey,
                                  values: RangeValues(minPrice, maxPrice),
                                  min: 0,
                                  max: 500,
                                  divisions: 50,
                                  labels: RangeLabels(
                                    '\$${minPrice.toInt()}',
                                    '\$${maxPrice.toInt()}',
                                  ),
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      minPrice = values.start;
                                      maxPrice = values.end;
                                    });
                                    context.read<ProductCubit>().filterProducts(
                                          category: selectedCategory,
                                          minPrice: minPrice,
                                          maxPrice: maxPrice,
                                          minRating: minRating,
                                        );
                                  },
                                ),
                                Text("Minimum Rating: ${minRating.toInt()}★"),
                                Slider(
                                    value: minRating,
                                    min: 0,
                                    max: 5,
                                    divisions: 5,
                                    label: minRating.toStringAsFixed(1),
                                    onChanged: (value) {
                                      setState(() {
                                        minRating = value;
                                        context
                                            .read<ProductCubit>()
                                            .filterProducts(
                                              category: selectedCategory,
                                              minPrice: minPrice,
                                              maxPrice: maxPrice,
                                              minRating: minRating,
                                            );
                                      });
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: productState.products.length,
                          itemBuilder: (context, index) {
                            final product = productState.products[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        product.image,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            const Icon(Icons.error, size: 80),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '\$${product.price}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.green),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${product.rating.rate}★",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.amber),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.category,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: Text('No products found'));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 15.0),
      child: SizedBox(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: 12,
      )),
    );
  }
}
