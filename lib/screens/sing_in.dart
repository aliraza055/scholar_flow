import 'package:flutter/material.dart';
import 'package:scholar_flow/Constants/app_theme.dart';
import 'package:scholar_flow/Core/Routers/app_routers.dart';
import 'package:scholar_flow/Services/auth_services.dart';
import 'package:scholar_flow/widgets/auth_social.dart';
import 'package:scholar_flow/widgets/textfeild.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback? onNavigateToSignUp;
  const SignInScreen({super.key, this.onNavigateToSignUp});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _keyform = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF1F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _keyform,
            child: Column(
              children: [
                const SizedBox(height: 48),

                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3A9BD5), Color(0xFF1B5E8C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Scholar Flow',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2433),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enter the Academic Sanctuary',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7A8D)),
                ),
                const SizedBox(height: 36),

                // White Card
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: const Text(
                          'Welcome back',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A2433),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Please enter your credentials to continue',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7A8D),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Email
                      const Text(
                        'EMAIL ADDRESS',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      AppTextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                        controller: _emailController,
                        hint: 'name@university.edu',
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 20),

                      // Password
                      const Text('PASSWORD', style: AppTextStyles.bodySmall),

                      const SizedBox(height: 8),
                      AppTextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                        obscureText: _obscurePassword,
                        controller: _passwordController,
                        hint: '••••••••',
                        icon: Icons.lock_outline_rounded,
                        suffix: GestureDetector(
                          onTap: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF8A97A5),
                            size: 20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_keyform.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              await Auth().signIn(
                                context,
                                _emailController.text,
                                _passwordController.text,
                              );
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E8C),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, size: 20),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'New to Scholar Flow? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7A8D),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRouters.signUP);
                            },
                            child: const Text(
                              'Create an account',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B5E8C),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // OR Divider
                      const SizedBox(height: 20),
                      SocialLoginRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
