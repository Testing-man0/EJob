import 'package:ecl_admin/screens/employee_list_page.dart';
import 'package:ecl_admin/screens/jobfrom.dart';
import 'package:ecl_admin/screens/matches_page.dart';
import 'package:flutter/material.dart';
import 'package:ecl_admin/widgets/nav_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return const JobFormPage(); // Transfer page
      case 1:
        return const EmployeeListPage();
      case 2:
        return const MatchesPage();
      default:
        return const Center(child: Text("Page Not Found"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavBar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(child: _getSelectedPage()),
        ],
      ),
    );
  }
}
