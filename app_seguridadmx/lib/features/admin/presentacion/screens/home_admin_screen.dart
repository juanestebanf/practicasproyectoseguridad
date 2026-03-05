
import 'package:flutter/material.dart';
import 'admin_dashboard_screen.dart';
import 'historial_alertas_screen.dart';
import 'admin_profile_screen.dart';
import 'operadores_screen.dart';
import '../widgets/admin_bottom_nav_widget.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AdminDashboardScreen(),
    OperadoresScreen(),
    HistorialAlertasScreen(),
    AdminProfileScreen(),
    
  ];

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AdminBottomNavWidget(
        currentIndex: _currentIndex,
        onTap: _changeTab,
        accent: const Color(0xFFE53935),
      ),
    );
  }
}