import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/admin_theme.dart';
import '../pages/api_management_page.dart';
import '../pages/customer_management_page.dart';
import '../pages/recipe_management_page.dart';
import '../pages/content_management_page.dart';
import '../pages/category_management_page.dart';
import '../pages/dashboard_home_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.key_rounded, label: 'API Keys'),
    _NavItem(icon: Icons.group_rounded, label: 'Customers'),
    _NavItem(icon: Icons.menu_book_rounded, label: 'Recipes'),
    _NavItem(icon: Icons.category_rounded, label: 'Categories'),
    _NavItem(icon: Icons.description_rounded, label: 'Content'),
  ];

  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardHomePage();
      case 1:
        return const ApiManagementPage();
      case 2:
        return const CustomerManagementPage();
      case 3:
        return const RecipeManagementPage();
      case 4:
        return const CategoryManagementPage();
      case 5:
        return const ContentManagementPage();
      default:
        return const DashboardHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = MediaQuery.of(context).size.width > 800;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Row(
        children: [
          // Modern Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isExpanded ? 260 : 72,
            decoration: const BoxDecoration(
              color: AdminTheme.sidebar,
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  offset: Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Logo header
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isExpanded ? 20 : 12,
                    vertical: 24,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/images/custom-images/favicon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (isExpanded) ...[
                        const SizedBox(width: 12),
                        Text(
                          'EatWise',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Divider(
                  color: AdminTheme.sidebarLight,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                const SizedBox(height: 12),

                // Navigation items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) {
                      final item = _navItems[index];
                      final isSelected = _selectedIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => setState(() => _selectedIndex = index),
                            hoverColor: AdminTheme.sidebarLight,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: EdgeInsets.symmetric(
                                horizontal: isExpanded ? 16 : 0,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AdminTheme.primary.withValues(alpha: 0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: isExpanded
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    item.icon,
                                    size: 22,
                                    color: isSelected
                                        ? AdminTheme.primary
                                        : Colors.white70,
                                  ),
                                  if (isExpanded) ...[
                                    const SizedBox(width: 12),
                                    Text(
                                      item.label,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? AdminTheme.primary
                                            : Colors.white70,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // User info + logout
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isExpanded ? 20 : 12,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AdminTheme.sidebarLight, width: 1),
                    ),
                  ),
                  child: isExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AdminTheme.primary,
                                  child: Text(
                                    (user?.email?.substring(0, 1) ?? 'A')
                                        .toUpperCase(),
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Admin',
                                          style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                      Text(user?.email ?? '',
                                          style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: Colors.white70),
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () =>
                                    FirebaseAuth.instance.signOut(),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  side: const BorderSide(color: Colors.white38),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.logout_rounded,
                                        size: 16, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text('Logout',
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : IconButton(
                          icon: const Icon(Icons.logout_rounded,
                              color: Colors.white, size: 22),
                          tooltip: 'Logout',
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.white12),
                          onPressed: () => FirebaseAuth.instance.signOut(),
                        ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(child: _getPage()),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}
