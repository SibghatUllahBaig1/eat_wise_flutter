import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/api_management_page.dart';
import '../pages/customer_management_page.dart';
import '../pages/recipe_management_page.dart';
import '../pages/content_management_page.dart';
import '../pages/dashboard_home_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.dashboard,
      label: 'Dashboard',
      page: const DashboardHomePage(),
    ),
    _NavItem(
      icon: Icons.key,
      label: 'API Management',
      page: const ApiManagementPage(),
    ),
    _NavItem(
      icon: Icons.people,
      label: 'Customers',
      page: const CustomerManagementPage(),
    ),
    _NavItem(
      icon: Icons.restaurant_menu,
      label: 'Recipes',
      page: const RecipeManagementPage(),
    ),
    _NavItem(
      icon: Icons.article,
      label: 'Content',
      page: const ContentManagementPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            extended: MediaQuery.of(context).size.width > 800,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            leading: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.admin_panel_settings,
                    size: 40,
                    color: Color(0xFF4B39EF),
                  ),
                  if (MediaQuery.of(context).size.width > 800) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'EatWise Admin',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
              ),
            ),
            destinations: _navItems
                .map((item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ))
                .toList(),
          ),

          const VerticalDivider(thickness: 1, width: 1),

          // Main content
          Expanded(
            child: _navItems[_selectedIndex].page,
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final Widget page;

  _NavItem({
    required this.icon,
    required this.label,
    required this.page,
  });
}

