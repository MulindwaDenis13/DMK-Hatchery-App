import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home.dart';
import './change_password.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../models/enums.dart';
import '../../widgets/button.dart';
import '../../widgets/input_field.dart';
import '../../widgets/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Controllers for form fields.
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Validation messages.
  String? _phoneError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      /// Listen for authentication results.
      listener: (context, state) {
        if (state.status == AppState.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message ?? "Login successful",
              ),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }

        if (state.status == AppState.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error ?? "Login failed",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },

      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Logo
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.shade50,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(.2),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.eco,
                          size: 56,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Center(
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: Text(
                        "Sign in to continue",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Phone Number
                    InputField(
                      controller: _phoneController,
                      label: "Phone Number",
                      hint: "0708757544",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      errorText: _phoneError,
                    ),

                    const SizedBox(height: 24),

                    /// Password
                    PasswordField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "Enter your password",
                      errorText: _passwordError,
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen(),
                            ),
                          );
                        },
                        child: const Text("Forgot Password?"),
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// Login Button
                    Button(
                      text: "Sign In",
                      icon: Icons.arrow_forward_rounded,
                      isLoading: state.status == AppState.loading,
                      onPressed: () => _login(context),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Sign Up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Validates the form and dispatches a Login event.
  void _login(BuildContext context) {
    setState(() {
      _phoneError = null;
      _passwordError = null;
    });

    bool hasError = false;

    if (_phoneController.text.trim().isEmpty) {
      _phoneError = "Phone number is required";
      hasError = true;
    }

    if (_passwordController.text.isEmpty) {
      _passwordError = "Password is required";
      hasError = true;
    } else if (_passwordController.text.length < 6) {
      _passwordError = "Password must be at least 6 characters";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    context.read<AuthBloc>().add(
          Login(
            phone: _phoneController.text,
            password: _passwordController.text,
          ),
        );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
