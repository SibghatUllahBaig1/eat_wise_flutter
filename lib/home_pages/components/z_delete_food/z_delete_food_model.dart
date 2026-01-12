import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/backend_manager.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'dart:ui';
import 'z_delete_food_widget.dart' show ZDeleteFoodWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZDeleteFoodModel extends FlutterFlowModel<ZDeleteFoodWidget> {
  final BackendManager _backend = BackendManager();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Delete meal from Firestore
  Future<void> deleteMeal(BuildContext context, String mealId) async {
    print('🗑️ DELETE MEAL CALLED');
    print('   Meal ID: $mealId');
    print('   Current User: $currentUserUid');

    if (currentUserUid.isEmpty) {
      print('❌ No user logged in');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to delete meals')),
        );
      }
      return;
    }

    if (mealId.isEmpty) {
      print('❌ No meal ID provided');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No meal ID to delete')),
        );
      }
      return;
    }

    try {
      print('🗑️ Deleting meal from Firestore...');
      print('   User ID: $currentUserUid');
      print('   Meal ID: $mealId');

      await _backend.mealService.deleteMeal(
        userId: currentUserUid,
        mealId: mealId,
      );

      print('✅ Meal deleted successfully from Firestore');

      if (!context.mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Food deleted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back to home page
      await Future.delayed(const Duration(milliseconds: 500));
      if (!context.mounted) return;

      context.goNamed('HomePage');
    } catch (e) {
      print('❌ Error deleting meal: $e');
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete food: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
