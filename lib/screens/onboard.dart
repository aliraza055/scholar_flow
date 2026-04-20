import 'package:flutter/material.dart';
import 'package:scholar_flow/Core/Routers/app_routers.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: WelcomeScreen()),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 56),

              // Logo
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE0E8F0), width: 1),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  size: 44,
                  color: Color(0xFF006692),
                ),
              ),

              const SizedBox(height: 24),

              // Badge pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F1FB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Education Platform',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0C447C),
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Title
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1D2939),
                    height: 1.15,
                  ),
                  children: [
                    TextSpan(text: 'Scholar\n'),
                    TextSpan(
                      text: 'Flow',
                      style: TextStyle(color: Color(0xFF006692)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Subtitle
              const Text(
                'Empowering educators with real-time analytics, seamless grading, and student management in one secure place.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF607D8B),
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 28),

              const Divider(color: Color(0xFFE0E8F0), thickness: 0.5),

              const SizedBox(height: 20),

              // Created by label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CREATED BY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF006692),
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Team members
              ..._teamMembers.map(
                (m) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      _Avatar(initials: m['initials']!),
                      const SizedBox(width: 12),
                      Text(
                        m['name']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1D2939),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Get Started button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRouters.bottomNav,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006692),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Log In button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD0D5DD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1D2939),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // // Page indicator dots
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     _Dot(active: true),
              //     const SizedBox(width: 6),
              //     _Dot(active: false),
              //     const SizedBox(width: 6),
              //     _Dot(active: false),
              //   ],
              // ),

              //  const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

const _teamMembers = [
  {'initials': '', 'name': 'Dil Rabaz Hussain'},
  {'initials': '', 'name': 'Amber Tanveer'},
  {'initials': '', 'name': 'Laiba Shoaib'},
];

class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: Color(0xFF006692),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0C447C),
        ),
      ),
    );
  }
}

// class _Dot extends StatelessWidget {
//   final bool active;
//   const _Dot({required this.active});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       width: active ? 18 : 6,
//       height: 6,
//       decoration: BoxDecoration(
//         color: const Color(0xFF006692).withOpacity(active ? 1.0 : 0.25),
//         borderRadius: BorderRadius.circular(3),
//       ),
//     );
//   }
// }
