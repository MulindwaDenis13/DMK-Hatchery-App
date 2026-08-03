import 'package:flutter/material.dart';
import 'invoices/invoices.dart';
import 'batches.dart';
import 'profile.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const BatchesScreen(),
    const InvoicesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home, color: Colors.green.shade700),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category, color: Colors.green.shade700),
            label: 'Batches',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long, color: Colors.green.shade700),
            label: 'Invoices',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person, color: Colors.green.shade700),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
