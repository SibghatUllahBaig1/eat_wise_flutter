import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Dynamic widget that fetches categories from Firestore and displays them
/// in a horizontal scrollable list (for Popular Categories section).
/// Uses a static cache so data is not reloaded on every navigation return.
class DynamicCategoriesWidget extends StatefulWidget {
  const DynamicCategoriesWidget({super.key});

  @override
  State<DynamicCategoriesWidget> createState() =>
      _DynamicCategoriesWidgetState();
}

class _DynamicCategoriesWidgetState extends State<DynamicCategoriesWidget> {
  // Static cache shared across all instances — survives navigation
  static List<Map<String, dynamic>>? _cachedCategories;

  @override
  Widget build(BuildContext context) {
    const double fixedHeight = 110.0;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('diet_categories')
          .orderBy('name')
          .snapshots(),
      builder: (context, snapshot) {
        // Update cache whenever fresh data arrives
        if (snapshot.hasData) {
          _cachedCategories = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        }

        // Use cached data immediately — no loading flash on navigation return
        final categories = _cachedCategories ?? [];

        // Only show spinner on the very first load (cache is empty)
        if (categories.isEmpty &&
            snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: fixedHeight,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (categories.isEmpty) {
          return SizedBox(
            height: fixedHeight,
            child: const Center(child: Text('No categories available')),
          );
        }

        return SizedBox(
          height: fixedHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: categories.map((data) {
                final emoji = data['emoji'] ?? '🍽️';
                final name = data['name'] ?? 'Unnamed';

                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(
                        DietsWidget.routeName,
                        queryParameters: {
                          'diets': serializeParam(name, ParamType.String),
                        }.withoutNulls,
                      );
                    },
                    child: Container(
                      width: 95.0,
                      height: 110.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: Center(
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 28.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Flexible(
                              child: Text(
                                name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      lineHeight: 1.2,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
