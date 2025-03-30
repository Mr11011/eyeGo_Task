import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_eyego/features/auth/cubit/auth_cubit.dart';
import 'package:task_eyego/features/auth/cubit/auth_states.dart';
import 'package:task_eyego/features/auth/widgets/customTextfield.dart';

import '../../products_feed/views/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordHidden = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade200,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/OB.png"),
              ),
            ),
          ),
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: BouncingScrollPhysics(),
            child: BlocConsumer<AuthCubit, AuthStates>(
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: const DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/images/char3.png"),
                            ),
                          ),
                        ),
                        Text(
                          "Create your account",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        CustomTextFormField(
                          labelText: "Email",
                          hintText: "Enter your email address",
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.attach_email_rounded,
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please enter your email",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              Fluttertoast.showToast(
                                msg: 'Enter a valid email',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          labelText: "Password",
                          hintText: "Enter your password",
                          prefixIcon: Icons.lock,
                          obscureText: isPasswordHidden,
                          suffixIcon: isPasswordHidden
                              ? Icons.visibility_sharp
                              : Icons.visibility_off,
                          onSuffixIconPressed: () {
                            setState(
                                () => isPasswordHidden = !isPasswordHidden);
                          },
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please enter your password",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              Fluttertoast.showToast(
                                msg: "Password must be at least 6 characters",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                              );
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          labelText: "Confirm Password",
                          hintText: "Re-enter your password",
                          prefixIcon: Icons.lock,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isPasswordHidden,
                          suffixIcon: isPasswordHidden
                              ? Icons.visibility_sharp
                              : Icons.visibility_off,
                          onSuffixIconPressed: () {
                            setState(
                                () => isPasswordHidden = !isPasswordHidden);
                          },
                          controller: confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please confirm your password",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text.trim()) {
                              Fluttertoast.showToast(
                                msg: "Passwords do not match",
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                              );
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ConditionalBuilder(
                          builder: (context) => ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signUp(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          condition: state is! AuthLoadingState,
                          fallback: (context) =>
                              Center(child: const CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                );
              },
              listener: (context, state) {
                if (state is AuthSuccessState) {
                  Fluttertoast.showToast(
                    msg: "Sign Up Successful",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: Colors.green,
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                }
                if (state is AuthErrorState) {
                  Fluttertoast.showToast(
                    msg: state.error,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: Colors.redAccent,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
