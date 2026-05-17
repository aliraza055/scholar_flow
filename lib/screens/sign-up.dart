import 'package:flutter/material.dart';
import 'package:scholar_flow/Constants/app_theme.dart';
import 'package:scholar_flow/Core/Routers/app_routers.dart';
import 'package:scholar_flow/Services/auth_services.dart';
import 'package:scholar_flow/widgets/auth_social.dart';
import 'package:scholar_flow/widgets/textfeild.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback? onNavigateToSignIn;
  const SignUpScreen({super.key, this.onNavigateToSignIn});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = false;
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

                // Logo
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
                      const Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A2433),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Join the academic community today',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7A8D),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Full Name
                      const Text('FULL NAME', style: AppTextStyles.labelSmall),
                      const SizedBox(height: 8),
                      AppTextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                        controller: _nameController,
                        hint: 'Enter you name',
                        icon: Icons.person_outline_rounded,
                      ),

                      const SizedBox(height: 20),

                      // Email
                      const Text(
                        'EMAIL ADDRESS',
                        style: AppTextStyles.labelSmall,
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
                        hint: 'name@university.com',
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 20),

                      // Subject
                      const Text('SUBJECT ', style: AppTextStyles.labelSmall),
                      const SizedBox(height: 8),
                      AppTextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                        controller: _subjectController,
                        hint: 'e.g. DSA',
                        icon: Icons.book_outlined,
                      ),

                      const SizedBox(height: 20),

                      // Password
                      const Text('PASSWORD', style: AppTextStyles.labelSmall),
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
                      SizedBox(height: 20),
                      // // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_keyform.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              await Auth().signUp(
                                context,
                                _nameController.text,
                                _emailController.text,
                                _passwordController.text,
                                _subjectController.text,
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
                                      'SingUP',
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
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7A8D),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRouters.signIn);
                            },
                            child: const Text(
                              'signIn',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E8C),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
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
