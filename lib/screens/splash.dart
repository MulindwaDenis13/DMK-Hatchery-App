import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _animationController.forward();

    // Navigate to login after 3 seconds
    Timer(const Duration(seconds: 3), () {
      _navigateToLogin();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF1B5E20),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1B5E20), // Dark green
              const Color(0xFF2E7D32), // Medium dark green
              const Color(0xFF388E3C), // Medium green
              const Color(0xFF43A047), // Light green
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon with animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade900.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.egg,
                            color: Color(0xFF2E7D32),
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // App Name with animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        Text(
                          'DMK Hatchery',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Quality Poultry & Hatchery Services',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.85),
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // Loading indicator
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 1500),
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Container(
                                width: 200 * value,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Version info
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.4),
                      letterSpacing: 0.5,
                    ),
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
