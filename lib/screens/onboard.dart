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
      backgroundColor: const Color(
        0xFFF8F9FB,
      ), // Light background to match the dashboard
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // 1. App Logo/Icon
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.school_rounded,
                  size: 50,
                  color: Color(0xFF006692),
                ),
              ),

              const SizedBox(height: 40),

              // 2. Main Title
              const Text(
                "Academic\nSanctuary",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1D2939),
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 20),

              // 3. Subtext (Reliable Value Proposition)
              const Text(
                "Empowering educators with real-time analytics, seamless grading, and student management in one secure place.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Created By:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006692),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'DIL RABAZ HUSSAIN \n  AMBER TANVEER \n LAIBA SHOAIB ',
                // textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D2939),
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // 4. Primary Action Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRouters.dashScreen,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006692),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 5. Secondary Action Button (Login)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD0D5DD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1D2939),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
