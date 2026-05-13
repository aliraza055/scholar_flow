import 'package:flutter/material.dart';
import 'package:scholar_flow/Services/auth_services.dart';
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
                      const Text('FULL NAME', style: _labelStyle),
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
                      const Text('EMAIL ADDRESS', style: _labelStyle),
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
                      const Text('SUBJECT ', style: _labelStyle),
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
                      const Text('PASSWORD', style: _labelStyle),
                      const SizedBox(height: 8),
                      AppTextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
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
                          onPressed: () {
                            if (_keyform.currentState!.validate()) {
                              Auth().signUp(
                                context,
                                _nameController.text,
                                _emailController.text,
                                _passwordController.text,
                                _subjectController.text,
                              );
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
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Create Account',
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7A8D),
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onNavigateToSignIn,
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B5E8C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Footer
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _labelStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w700,
  color: Color(0xFF6B7A8D),
  letterSpacing: 1.2,
);

InputDecoration _inputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffix,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFABB5C2), fontSize: 15),
    prefixIcon: Icon(icon, color: const Color(0xFF8A97A5), size: 20),
    suffixIcon: suffix,
    filled: true,
    fillColor: const Color(0xFFECF0F5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF1B5E8C), width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
  );
}
