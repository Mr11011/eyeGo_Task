import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_eyego/features/auth/cubit/auth_cubit.dart';
import 'package:task_eyego/features/auth/cubit/auth_states.dart';
import 'package:task_eyego/features/products_feed/controller/product_cubit.dart';
import 'package:task_eyego/features/products_feed/services/product_service.dart';
import '../../auth/views/sign_in_screen.dart';
import '../controller/products_states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  return const Center(child: CircularProgressIndicator());
                } else if (productState is ProductsSuccessState) {
                  return Column(
                    children: [
                      // 👇 Search Bar (TextField)
                      Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SearchBar(
                            hintText: 'Search products...',
                            leading: Icon(Icons.search),
                            onChanged: (query){},
                            keyboardType: TextInputType.text,
                            // TextField(
                            //   decoration: InputDecoration(
                            //     hintText: 'Search products...',
                            //     prefixIcon: const Icon(Icons.search),
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //   ),
                            //   onChanged: (query) {
                            //     // 👇 Filter products based on search (using Bloc)
                            //     // context.read<ProductCubit>().searchProducts(query);
                            //   },
                            // ),
                          )),
                      // 👇 Product List (Now using ListView.builder for better performance)
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
                                        fit: BoxFit.cover,
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
}

// deepseek code:

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//       ProductCubit(productService: ProductService())..fetchProducts(),
//       child: BlocConsumer<AuthCubit, AuthStates>(
//         listener: (context, authState) {
//           if (authState is AuthSignOutState) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const SignInScreen()),
//             );
//           }
//         },
//         builder: (context, authState) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Products'),
//               actions: [
//                 IconButton(
//                   onPressed: () {
//                     context.read<AuthCubit>().signOut();
//                   },
//                   icon: const Icon(Icons.logout),
//                 ),
//               ],
//             ),
//             body: BlocConsumer<ProductCubit, ProductsStates>(
//               listener: (context, productState) {
//                 if (productState is ProductsErrorState) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: ${productState.error}')),
//                   );
//                 }
//               },
//               builder: (context, productState) {
//                 if (productState is ProductsLoadingState) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (productState is ProductsSuccessState) {
//                   return SingleChildScrollView(
//                     physics: BouncingScrollPhysics(),
//                     keyboardDismissBehavior:
//                     ScrollViewKeyboardDismissBehavior.onDrag,
//                     child: Column(
//                       children: productState.products.map((product) {
//                         return Card(
//                           elevation: 2,
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 16),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Image.network(
//                                     product.image,
//                                     width: 80,
//                                     height: 80,
//                                     fit: BoxFit.contain,
//                                     errorBuilder:
//                                         (context, error, stackTrace) =>
//                                     const Icon(Icons.error, size: 80),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         product.title,
//                                         style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         '\$${product.price}',
//                                         style: const TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.green,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         product.category,
//                                         style: const TextStyle(
//                                             fontSize: 14, color: Colors.grey),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 }
//                 return const Center(child: Text('No products found'));
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// with shimmer
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//       ProductCubit(productService: ProductService())..fetchProducts(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Products'),
//           actions: [
//             IconButton(
//               onPressed: () => context.read<AuthCubit>().signOut(),
//               icon: const Icon(Icons.logout),
//             ),
//           ],
//         ),
//         body: BlocConsumer<ProductCubit, ProductsStates>(
//           listener: (context, productState) {
//             if (productState is ProductsErrorState) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Error: ${productState.error}')),
//               );
//             }
//           },
//           builder: (context, productState) {
//             if (productState is ProductsLoadingState) {
//               return _buildShimmerEffect();
//             } else if (productState is ProductsSuccessState) {
//               return _buildProductGrid(productState);
//             }
//             return const Center(child: Text('No products found'));
//           },
//         ),
//       ),
//     );
//   }
//
//   /// **🔹 Grid View for Products**
//   Widget _buildProductGrid(ProductsSuccessState state) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: GridView.builder(
//         itemCount: state.products.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // 2 columns for better visibility
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 0.9,
//         ),
//         itemBuilder: (context, index) {
//           final product = state.products[index];
//           return Card(
//             elevation: 3,
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius:
//                     const BorderRadius.vertical(top: Radius.circular(12)),
//                     child: Image.network(
//                       product.image,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) =>
//                       const Icon(Icons.error),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.title,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 4),
//                       Text('\$${product.price}',
//                           style: const TextStyle(color: Colors.green)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   /// **🔹 Shimmer Effect for Loading State**
//   Widget _buildShimmerEffect() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: GridView.builder(
//         itemCount: 6, // Show 6 placeholders
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 0.7,
//         ),
//         itemBuilder: (context, index) {
//           return Shimmer.fromColors(
//             baseColor: Colors.grey.shade300,
//             highlightColor: Colors.grey.shade100,
//             child: Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Column(
//                 children: [
//                   Container(
//                     height: 120,
//                     width: double.infinity,
//                     color: Colors.white,
//                   ),
//                   const SizedBox(height: 10),
//                   Container(height: 10, width: 80, color: Colors.white),
//                   const SizedBox(height: 5),
//                   Container(height: 10, width: 60, color: Colors.white),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
