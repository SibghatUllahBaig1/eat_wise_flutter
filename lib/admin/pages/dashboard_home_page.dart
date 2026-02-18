import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

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
                  childAspectRatio: 2,
                  children: [
                    _StatCard(
                      title: 'Total Users',
                      icon: Icons.people,
                      color: Colors.blue,
                      future: _getTotalUsers(),
                    ),
                    _StatCard(
                      title: 'Total Recipes',
                      icon: Icons.restaurant_menu,
                      color: Colors.green,
                      future: _getTotalRecipes(),
                    ),
                    _StatCard(
                      title: 'Active Subscriptions',
                      icon: Icons.card_membership,
                      color: Colors.orange,
                      future: _getActiveSubscriptions(),
                    ),
                    _StatCard(
                      title: 'Total Meals Logged',
                      icon: Icons.fastfood,
                      color: Colors.purple,
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
        if (data?['status'] == 'active') {
          count++;
        }
      }
    }

    return count;
  }

  Future<int> _getTotalMeals() async {
    // This is an approximation - counting all meals across all users
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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            FutureBuilder<int>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return Text(
                  snapshot.data?.toString() ?? '0',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

