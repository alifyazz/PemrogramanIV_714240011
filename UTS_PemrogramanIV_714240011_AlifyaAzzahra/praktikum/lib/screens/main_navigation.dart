import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'contact_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ContactScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UTS Pemrograman IV',
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFB56576),
        elevation: 2,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFFF28482),
                fontWeight: FontWeight.w600,
              );
            }
            return const TextStyle(fontFamily: 'Poppins', color: Colors.white70);
          }),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: const Color(0xFF352F44),
          // Mengubah warna latar belakang ikon aktif menjadi transparan
          indicatorColor: Colors.transparent, 
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white70),
              selectedIcon: Icon(Icons.home_rounded, color: Color(0xFFF28482)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.contacts_outlined, color: Colors.white70),
              selectedIcon: Icon(Icons.contacts_rounded, color: Color(0xFFF28482)),
              label: 'Contact List',
            ),
          ],
        ),
      ),
    );
  }
}