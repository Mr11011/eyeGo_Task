import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_eyego/features/auth/cubit/auth_cubit.dart';
import 'package:task_eyego/features/auth/views/sign_in_screen.dart';
import 'package:task_eyego/features/products_feed/controller/product_cubit.dart';
import 'package:task_eyego/features/products_feed/services/product_service.dart';
import 'package:task_eyego/features/products_feed/views/home_screen.dart';
import 'core/blocObserver.dart';
import 'core/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();

  final secureStorage = const FlutterSecureStorage();
  final token = await secureStorage.read(key: "authToken");

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AuthCubit(
              firebaseAuth: FirebaseAuth.instance,
              secureStorage: secureStorage),
        ),
        // BlocProvider(
        //   create: (BuildContext context) =>
        //       ProductCubit(productService: ProductService()),
        // ),
      ],
      child: MyApp(
        isLoggedIn: token != null,
      ),
    ), // Wrap your app
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      theme: ThemeData(fontFamily: GoogleFonts.kanit().fontFamily),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomeScreen() : SignInScreen(),
    );
  }
}
