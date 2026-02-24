import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/admin_theme.dart';

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text(
              'Welcome back! Here\'s an overview of your app.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // Stats cards
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 1200
                    ? 4
                    : constraints.maxWidth > 800
                        ? 2
                        : 1;

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2.2,
                  children: [
                    _StatCard(
                      title: 'Total Users',
                      icon: Icons.people_rounded,
                      color: AdminTheme.cardBlue,
                      future: _getTotalUsers(),
                    ),
                    _StatCard(
                      title: 'Total Recipes',
                      icon: Icons.restaurant_menu_rounded,
                      color: AdminTheme.cardGreen,
                      future: _getTotalRecipes(),
                    ),
                    _StatCard(
                      title: 'Active Subscriptions',
                      icon: Icons.card_membership_rounded,
                      color: AdminTheme.cardOrange,
                      future: _getActiveSubscriptions(),
                    ),
                    _StatCard(
                      title: 'Meals Logged',
                      icon: Icons.fastfood_rounded,
                      color: AdminTheme.cardPurple,
                      future: _getTotalMeals(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<int> _getTotalUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.size;
  }

  Future<int> _getTotalRecipes() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('recipes').get();
    return snapshot.size;
  }

  Future<int> _getActiveSubscriptions() async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    int count = 0;
    for (var userDoc in usersSnapshot.docs) {
      final subDoc = await userDoc.reference
          .collection('subscription')
          .doc('current')
          .get();
      if (subDoc.exists) {
        final data = subDoc.data();
        if (data?['status'] == 'active') count++;
      }
    }
    return count;
  }

  Future<int> _getTotalMeals() async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    int count = 0;
    for (var userDoc in usersSnapshot.docs) {
      final mealsSnapshot =
          await userDoc.reference.collection('meals').count().get();
      count += mealsSnapshot.count ?? 0;
    }
    return count;
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Future<int> future;

  const _StatCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.future,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AdminTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AdminTheme.textSecondary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          FutureBuilder<int>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                );
              }
              return Text(
                _formatNumber(snapshot.data ?? 0),
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AdminTheme.textPrimary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }
}
