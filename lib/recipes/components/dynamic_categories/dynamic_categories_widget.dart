import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Dynamic widget that fetches categories from Firestore and displays them
/// in a horizontal scrollable list (for Popular Categories section)
class DynamicCategoriesWidget extends StatelessWidget {
  const DynamicCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('diet_categories')
          .orderBy('name')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading categories'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final categories = snapshot.data?.docs ?? [];

        if (categories.isEmpty) {
          return Center(
            child: Text('No categories available'),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: categories.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final emoji = data['emoji'] ?? '🍽️';
              final name = data['name'] ?? 'Unnamed';
              final key = data['key'] ?? '';

              return Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed(
                      DietsWidget.routeName,
                      queryParameters: {
                        'diets': serializeParam(
                          name,
                          ParamType.String,
                        ),
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
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Emoji icon (no background)
                          SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: Center(
                              child: Text(
                                emoji,
                                style: TextStyle(fontSize: 28.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          // Category name
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
        );
      },
    );
  }
}
